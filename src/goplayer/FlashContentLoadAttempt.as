package goplayer
{
  import flash.display.Loader
  import flash.events.Event
  import flash.events.IOErrorEvent
  import flash.net.URLRequest
  import flash.system.ApplicationDomain
  import flash.system.LoaderContext
  import flash.system.SecurityDomain

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
    }

    public function execute() : void
    { loader.load(new URLRequest(url)) }

    private function handleContentLoaded(event : Event) : void
    { listener.handleContentLoaded(loader.contentLoaderInfo) }

    private function handleIOError(event : IOErrorEvent) : void
    { debug("Failed to load <" + url + ">: " + event.text) }
  }
}
