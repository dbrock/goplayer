package goplayer
{
  import flash.events.TimerEvent
  import flash.media.Video
  import flash.utils.Timer

  import org.asspec.util.sequences.ArraySequenceContainer
  import org.asspec.util.sequences.SequenceContainer

  public class RTMPStreamPlayer
    implements FlashNetConnectionListener, FlashNetStreamListener
  {
    private const DEFAULT_VOLUME : Number = .8
    private const listeners : SequenceContainer
      = new ArraySequenceContainer
    private const timer : Timer = new Timer(30)
 
    private var metadata : RTMPStreamMetadata
    private var connection : FlashNetConnection

    private var stream : FlashNetStream = null
    private var hotMetadata : Object = null

    private var _volume : Number = DEFAULT_VOLUME
    private var _paused : Boolean = false

    public function RTMPStreamPlayer
      (metadata : RTMPStreamMetadata,
       connection : FlashNetConnection)
    {
      this.metadata = metadata
      this.connection = connection

      connection.listener = this

      timer.addEventListener(TimerEvent.TIMER, withoutArguments(update))
      timer.start()
    }

    private function update() : void
    {
      for each (var listener : RTMPStreamPlayerListener in listeners)
        listener.handleRTMPStreamUpdated()
    }

    public function addListener(listener : RTMPStreamPlayerListener) : void
    { listeners.add(listener) }

    public function start() : void
    {
      debug("Connecting to <" + metadata.url + ">...")
      
      try
        { connection.connect(metadata.url) }
      catch (error : Error)
        { debug("Failed to connect: " + error.message) }
    }

    public function handleNetConnectionStatus(code : String) : void
    {
      if (code == "NetConnection.Connect.Success")
        handleConnectionSuccessful()
      else if (code == "NetConnection.Connect.Closed")
        debug("Connection closed.")
      else if (code == "NetConnection.Connect.NetworkChange")
        debug("Detected change in network conditions.")
      else if (code == "NetConnection.Connect.IdleTimeOut")
        debug("Closing idle connection.")
      else
        debug("Net connection status: " + code)
    }

    private function handleConnectionSuccessful() : void
    {
      stream = connection.getNetStream()
      stream.listener = this

      stream.bufferTime = Duration.seconds(5)
      stream.volume = volume

      stream.play(metadata.name)

      if (paused)
        stream.paused = true

      for each (var listener : RTMPStreamPlayerListener in listeners)
        listener.handleRTMPStreamCreated()
    }

    public function attachVideo(video : Video) : void
    { stream.attachVideo(video) }

    public function handleNetStreamMetadata(data : Object) : void
    { hotMetadata = data }

    public function handleNetConnectionAsyncError(message : String) : void
    { debug("Asynchronuous connection error: " + message) }

    public function handleNetStreamAsyncError(message : String) : void
    { debug("Asynchronuous stream error: " + message) }

    public function handleNetStreamStatus(code : String) : void
    {
      if (code == "NetStream.Play.Reset")
        {}
      else if (code == "NetStream.Play.Start")
        handleStreamingStarted()
      else if (code == "NetStream.Play.Stop")
        handleStreamingStopped()
      else if (code == "NetStream.Buffer.Full")
        debug("Buffer filled; ready for playback.")
      else if (code == "NetStream.Buffer.Flush")
        debug("Flushing buffer.")
      else if (code == "NetStream.Buffer.Empty")
        handleBufferEmpty()
      else if (code == "NetStream.Pause.Notify")
        debug("Playback paused.")
      else if (code == "NetStream.Unpause.Notify")
        debug("Playback resumed.")
      else if (code == "NetStream.Seek.Notify")
        debug("Seeked.")
      else
        debug("Net stream status: " + code)
    }

    private function handleStreamingStarted() : void
    { debug("Data streaming started; filling buffer.") }

    private function handleStreamingStopped() : void
    {
      debug("Data streaming stopped.")
      handleMaybeFinishedPlaying()
    }

    private function handleBufferEmpty() : void
    {
      debug("Buffer empty; stopping playback.")
      handleMaybeFinishedPlaying()
    }

    private function handleMaybeFinishedPlaying() : void
    {
      if (finishedPlaying)
        handleFinishedPlaying()
    }

    private function handleFinishedPlaying() : void
    {
      debug("Finished playing.")

      for each (var listener : RTMPStreamPlayerListener in listeners)
        listener.handleRTMPStreamFinishedPlaying()
    }

    private function get finishedPlaying() : Boolean
    { return timeRemaining.seconds < 1 }

    private function get timeRemaining() : Duration
    { return streamLength.minus(playheadPosition) }

    // -----------------------------------------------------

    public function get paused() : Boolean
    { return _paused }

    public function set paused(value : Boolean) : void
    {
      _paused = value

      if (stream)
        stream.paused = value
    }

    public function togglePaused() : void
    { paused = !paused }

    // -----------------------------------------------------

    public function get playheadPosition() : Duration
    { return stream ? stream.playheadPosition : Duration.ZERO }

    public function set playheadPosition(value : Duration) : void
    { stream.playheadPosition = value }

    public function seekBy(delta : Duration) : void
    { playheadPosition = playheadPosition.plus(delta) }

    public function rewind() : void
    { playheadPosition = Duration.ZERO }

    // -----------------------------------------------------

    public function get volume() : Number
    { return _volume }

    public function set volume(value : Number) : void
    {
      _volume = value

      if (stream)
        stream.volume = value
    }

    public function changeVolumeBy(delta : Number) : void
    { volume = volume + delta }

    // -----------------------------------------------------

    public function get bufferTime() : Duration
    { return stream ? stream.bufferTime : Duration.ZERO }

    public function get bufferLength() : Duration
    { return stream ? stream.bufferLength : Duration.ZERO }

    public function get streamLength() : Duration
    {
      return hotMetadata
        ? Duration.seconds(hotMetadata.duration)
        : metadata.duration
    }

    public function get dimensions() : Dimensions
    {
      return hotMetadata
        ? new Dimensions(hotMetadata.width, hotMetadata.height)
        : metadata.dimensions
    }
  }
}
