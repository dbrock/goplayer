package goplayer
{
  import flash.events.AsyncErrorEvent
  import flash.events.NetStatusEvent
  import flash.net.NetConnection
  import flash.net.NetStream

  public class RTMPStreamPlayerEngine
  {
    private const connection : NetConnection = new NetConnection
 
    private var metadata : RTMPStreamMetadata
    private var view : RTMPStreamPlayer

    private var stream : NetStream = null
    private var hotMetadata : Object = null

    public function RTMPStreamPlayerEngine
      (metadata : RTMPStreamMetadata, view : RTMPStreamPlayer)
    {
      this.metadata = metadata
      this.view = view

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

      view.handleNetStreamCreated(stream)

      stream.bufferTime = 5
      stream.play(metadata.name)
    }

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
        debug("Buffer full; starting playback.")
      else if (code == "NetStream.Buffer.Flush")
        debug("Will play buffered data (" + bufferLength + "s).")
      else if (code == "NetStream.Buffer.Empty")
        debug("Buffer empty; stopping playback.")
      else
        debug("Net stream status: " + code)
    }

    // -----------------------------------------------------

    public function get playheadPosition() : Number
    { return stream ? stream.time : NaN }

    public function get bufferTime() : Number
    { return stream ? stream.bufferTime : NaN }

    public function get bufferLength() : Number
    { return stream ? stream.bufferLength : NaN }

    public function get duration() : Number
    { return hotMetadata ? hotMetadata.duration : metadata.duration }

    public function get dimensions() : Dimensions
    {
      return hotMetadata
        ? new Dimensions(hotMetadata.width, hotMetadata.height)
        : metadata.dimensions
    }
  }
}
