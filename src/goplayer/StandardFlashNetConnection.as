package goplayer
{
  import flash.events.AsyncErrorEvent
  import flash.events.NetStatusEvent
  import flash.net.NetConnection
  import flash.net.NetStream

  public class StandardFlashNetConnection implements FlashNetConnection
  {
    private const connection : NetConnection = new NetConnection

    private var _listener : FlashNetConnectionListener

    public function StandardFlashNetConnection()
    {
      connection.addEventListener
        (NetStatusEvent.NET_STATUS, handleNetConnectionStatus)
      connection.addEventListener
        (AsyncErrorEvent.ASYNC_ERROR, handleAsyncError)
      connection.client = {}      
    }

    public function set listener(value : FlashNetConnectionListener) : void
    { _listener = value }

    public function connect(url : URL) : void
    { connection.connect(url.toString()) }

    public function getNetStream() : FlashNetStream
    { return new StandardFlashNetStream(connection) }

    private function handleNetConnectionStatus(event : NetStatusEvent) : void
    { _listener.handleNetConnectionStatus(event.info.code) }

    private function handleAsyncError(event : AsyncErrorEvent) : void
    { _listener.handleNetConnectionAsyncError(event.error.message) }
  }
}
