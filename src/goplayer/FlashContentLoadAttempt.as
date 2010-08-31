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
    {
      const code : String = event.text.match(/^Error #(\d+)/)[1]      
      const message : String = code == "2035" ? "Not found" : event.text

      debug("Error: Failed to load <" + url + ">: " + message)
    }

    private function handleSecurityError(event : SecurityErrorEvent) : void
    { debug("Error: Failed to load <" + url + ">: " + event.text) }
  }
}
