package goplayer
{
  import flash.events.AsyncErrorEvent
  import flash.events.NetStatusEvent
  import flash.media.Video
  import flash.net.NetConnection
  import flash.net.NetStream

  public class StandardFlashNetConnection implements FlashNetConnection
  {
    private const connection : NetConnection = new NetConnection

    private var video : Video

    private var _listener : FlashNetConnectionListener

    public function StandardFlashNetConnection(video : Video)
    {
      this.video = video

      connection.addEventListener
        (NetStatusEvent.NET_STATUS, handleNetConnectionStatus)
      connection.addEventListener
        (AsyncErrorEvent.ASYNC_ERROR, handleAsyncError)
      connection.client = {}      
    }

    public function set listener(value : FlashNetConnectionListener) : void
    { _listener = value }

    public function connect(url : URL) : void
    {
      debug("Connecting to <" + url + ">...")
      
      try
        { connection.connect(url.toString()) }
      catch (error : Error)
        { _listener.handleConnectionFailed() }
    }

    public function getNetStream() : FlashNetStream
    { return new StandardFlashNetStream(connection, video) }

    private function handleNetConnectionStatus(event : NetStatusEvent) : void
    {
      const code : String = event.info.code

      if (code == CONNECTION_ESTABLISHED)
        _listener.handleConnectionEstablished()
      else if (code == CONNECTION_FAILED)
        _listener.handleConnectionFailed()
      else if (code == CONNECTION_CLOSED)
        _listener.handleConnectionClosed()

      if (code == CONNECTION_ESTABLISHED)
        debug("Connection established.")
      else if (code == CONNECTION_FAILED)
        debug("Connection failed.")
      else if (code == CONNECTION_CLOSED)
        debug("Connection closed.")
      else if (code == NETWORK_CHANGED)
        debug("Detected change in network conditions.")
      else if (code == IDLE_TIME_OUT)
        debug("Closing idle connection.")
      else
        debug("Net connection status: " + code)
    }

    private function handleAsyncError(event : AsyncErrorEvent) : void
    { debug("Asynchronuous connection error: " + event.error.message) }

    private static const CONNECTION_ESTABLISHED : String
      = "NetConnection.Connect.Success"
    private static const CONNECTION_FAILED : String
      = "NetConnection.Connect.Failed"
    private static const CONNECTION_CLOSED : String
      = "NetConnection.Connect.Closed"
    private static const NETWORK_CHANGED : String
      = "NetConnection.Connect.NetworkChange"
    private static const IDLE_TIME_OUT : String
      = "NetConnection.Connect.IdleTimeOut"
  }
}
