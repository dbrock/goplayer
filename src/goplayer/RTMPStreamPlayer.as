package goplayer
{
  import flash.events.AsyncErrorEvent
  import flash.events.NetStatusEvent
  import flash.media.SoundTransform
  import flash.media.Video
  import flash.net.NetConnection
  import flash.net.NetStream

  public class RTMPStreamPlayer
  {
    private const DEFAULT_VOLUME : Number = .8
    private const connection : NetConnection = new NetConnection
 
    private var metadata : RTMPStreamMetadata

    public var listener : RTMPStreamPlayerListener

    private var stream : NetStream = null
    private var hotMetadata : Object = null

    public function RTMPStreamPlayer(metadata : RTMPStreamMetadata)
    {
      this.metadata = metadata

      connection.addEventListener
        (NetStatusEvent.NET_STATUS, handleNetConnectionStatus)
      connection.addEventListener
        (AsyncErrorEvent.ASYNC_ERROR, handleAsyncError)
      connection.client = {}
    }

    public function start() : void
    {
      debug("Connecting to <" + metadata.url + ">...")
      
      try
        { connection.connect(metadata.url) }
      catch (error : Error)
        { debug("Failed to connect: " + error.message) }
    }

    private function handleNetConnectionStatus
      (event : NetStatusEvent) : void
    {
      if (event.info.code == "NetConnection.Connect.Success")
        handleConnectionSuccessful()
      else if (event.info.code == "NetConnection.Connect.Closed")
        debug("Connection closed.")
      else if (event.info.code == "NetConnection.Connect.NetworkChange")
        debug("Detected change in network conditions.")
      else
        debug("Net connection status: " + event.info.code)
    }

    private function handleConnectionSuccessful() : void
    {
      stream = new NetStream(connection)
      stream.addEventListener
        (NetStatusEvent.NET_STATUS, handleNetStreamStatus)
      stream.addEventListener
        (AsyncErrorEvent.ASYNC_ERROR, handleAsyncError)
      stream.client = { onMetaData: handleNetStreamMetadata }

      volume = DEFAULT_VOLUME

      stream.bufferTime = 5
      stream.play(metadata.name)

      listener.handleRTMPStreamEstablished()
    }

    public function attachVideo(video : Video) : void
    { video.attachNetStream(stream) }

    private function handleNetStreamMetadata(data : Object) : void
    { hotMetadata = data }

    private function handleAsyncError(event : AsyncErrorEvent) : void
    { debug("Asynchronuous error: " + event.error.message) }

    private function handleNetStreamStatus
      (event : NetStatusEvent) : void
    {
      const code : String = event.info.code

      if (code == "NetStream.Play.Reset")
        {}
      else if (code == "NetStream.Play.Start")
        debug("Data streaming started; filling buffer.")
      else if (code == "NetStream.Play.Stop")
        debug("Data streaming stopped.")
      else if (code == "NetStream.Buffer.Full")
        debug("Buffer filled; ready for playback.")
      else if (code == "NetStream.Buffer.Flush")
        {}
      else if (code == "NetStream.Buffer.Empty")
        debug("Buffer empty; stopping playback.")
      else if (code == "NetStream.Pause.Notify")
        debug("Playback paused.")
      else if (code == "NetStream.Unpause.Notify")
        debug("Playback resumed.")
      else if (code == "NetStream.Seek.Notify")
        debug("Seeked.")
      else
        debug("Net stream status: " + code)
    }

    public function togglePaused() : void
    { stream.togglePause() }

    public function seek(delta : Number) : void
    { stream.seek(playheadPosition + delta) }

    public function changeVolume(delta : Number) : void
    { volume = volume + delta }

    public function set volume(value : Number) : void
    {
      try
        { stream.soundTransform = getSoundTransform(value) }
      catch (error : Error)
        {}
    }

    private function getSoundTransform(volume : Number) : SoundTransform
    {
      const result : SoundTransform = new SoundTransform

      result.volume = clamp(volume, 0, 1)

      return result
    }

    // -----------------------------------------------------

    public function get playheadPosition() : Number
    { return stream ? stream.time : 0 }

    public function get bufferTime() : Number
    { return stream ? stream.bufferTime : 0 }

    public function get bufferLength() : Number
    { return stream ? stream.bufferLength : 0 }

    public function get volume() : Number
    { return stream ? stream.soundTransform.volume : DEFAULT_VOLUME }

    public function get streamLength() : Number
    { return hotMetadata ? hotMetadata.duration : metadata.duration }

    public function get dimensions() : Dimensions
    {
      return hotMetadata
        ? new Dimensions(hotMetadata.width, hotMetadata.height)
        : metadata.dimensions
    }
  }
}
