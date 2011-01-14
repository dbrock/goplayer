package goplayer
{
  import flash.events.Event
  import flash.events.IOErrorEvent
  import flash.events.SecurityErrorEvent
  import flash.net.URLLoader

  public class HTTPFetchAttempt
  {
    private const loader : URLLoader = new URLLoader

    private var url : URL
    private var handler : HTTPResponseHandler

    public function HTTPFetchAttempt
      (url : URL, handler : HTTPResponseHandler)
    { this.url = url, this.handler = handler }

    public function execute() : void
    {
      loader.addEventListener
        (Event.COMPLETE, handleContentLoaded)
      loader.addEventListener
        (IOErrorEvent.IO_ERROR, handleIOError)
      loader.addEventListener
        (SecurityErrorEvent.SECURITY_ERROR, handleSecurityError)

      loader.load(url.asURLRequest)
    }

    private function handleContentLoaded(event : Event) : void
    { handler.handleHTTPResponse(loader.data) }

    private function handleIOError(event : IOErrorEvent) : void
    { handler.handleHTTPError(event.text) }

    private function handleSecurityError(event : SecurityErrorEvent) : void
    { handler.handleHTTPError(event.text) }
  }
}
