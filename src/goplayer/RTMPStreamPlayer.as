package goplayer
{
  public class RTMPStreamPlayer
    implements FlashNetConnectionListener, FlashNetStreamListener
  {
    private const DEFAULT_VOLUME : Number = .8

    private var metadata : RTMPStreamMetadata
    private var connection : FlashNetConnection

    private var _listener : RTMPStreamPlayerListener = null

    private var connector : RTMPConnector = null
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
    }

    public function set listener(value : RTMPStreamPlayerListener) : void
    { _listener = value }

    // -----------------------------------------------------

    public function start() : void
    {
      connector = new RTMPConnector(connection, metadata.url)
      connector.tryNextPort()
    }

    public function handleNetConnectionFailed() : void
    {
      debug("Connection failed.")

      if (connector.hasMoreIdeas)
        connector.tryNextPort()
      else
        debug("Tried all alternative ports; giving up.")
    }

    // -----------------------------------------------------

    public function handleNetConnectionEstablished() : void
    {
      stream = connection.getNetStream()
      stream.listener = this

      stream.bufferTime = Duration.seconds(5)
      stream.volume = volume

      stream.play(metadata.name)

      if (paused)
        stream.paused = true
    }

    public function handleNetConnectionClosed() : void
    { debug("Connection closed.") }

    public function handleNetStreamMetadata(data : Object) : void
    { hotMetadata = data }

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
      _listener.handleRTMPStreamFinishedPlaying()
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
