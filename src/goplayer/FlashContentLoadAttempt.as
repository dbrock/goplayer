package goplayer
{
  import flash.display.Loader
  import flash.events.Event
  import flash.events.IOErrorEvent
  import flash.events.SecurityErrorEvent
  import flash.net.URLRequest

  public class FlashContentLoadAttempt
  {
    private const loader : Loader = new Loader

    private var url : String
    private var listener : FlashContentLoaderListener

    public function FlashContentLoadAttempt
      (url : String, listener : FlashContentLoaderListener)
    {
      this.url = url, this.listener = listener

      loader.contentLoaderInfo.addEventListener
        (Event.COMPLETE, handleContentLoaded)
      loader.contentLoaderInfo.addEventListener
        (IOErrorEvent.IO_ERROR, handleIOError)
      loader.contentLoaderInfo.addEventListener
        (SecurityErrorEvent.SECURITY_ERROR, handleSecurityError)
    }

    public function execute() : void
    { loader.load(new URLRequest(url)) }

    private function handleContentLoaded(event : Event) : void
    { listener.handleContentLoaded(loader.contentLoaderInfo) }

    private function handleIOError(event : IOErrorEvent) : void
    { handleError(event.text) }

    private function handleSecurityError(event : SecurityErrorEvent) : void
    { handleError(event.text) }

    private function handleError(message : String) : void
    {
      debug("Error: Failed to load <" + url + ">: "
            + getErrorMessage(message))
    }

    private function getErrorMessage(message : String) : String
    { return getErrorCode(message) == "2035" ? "Not found" : message }

    private function getErrorCode(message : String) : String
    { return message.match(/^Error #(\d+)/)[1] }
  }
}
