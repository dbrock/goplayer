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
      connection.connect(url.toString())
    }

    public function getNetStream() : FlashNetStream
    { return new StandardFlashNetStream(connection, video) }

    private function handleNetConnectionStatus(event : NetStatusEvent) : void
    { _listener.handleNetConnectionStatus(event.info.code) }

    private function handleAsyncError(event : AsyncErrorEvent) : void
    { _listener.handleNetConnectionAsyncError(event.error.message) }
  }
}
