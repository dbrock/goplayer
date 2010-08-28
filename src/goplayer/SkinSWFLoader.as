package goplayer
{
  import flash.display.LoaderInfo
  import flash.utils.getQualifiedClassName

  public class SkinSWFLoader implements FlashContentLoaderListener
  {
    private var url : String
    private var listener : SkinSWFLoaderListener

    public function SkinSWFLoader
      (url : String, listener : SkinSWFLoaderListener)
    { this.url = url, this.listener = listener }

    public function execute() : void
    {
      debug("Loading skin SWF <" + url + ">...")
      new FlashContentLoader().load(url, this)
    }

    public function handleContentLoaded(info : LoaderInfo) : void
    {
      if (!(info.content is SkinSWF))
        debug("Error: Skin SWF must implement " + interfaceName)
      else
        handleSkinSWFLoaded(SkinSWF(info.content))
    }

    private function get interfaceName() : String
    { return getQualifiedClassName(SkinSWF) }

    private function handleSkinSWFLoaded(swf : SkinSWF) : void
    {
      debug("Skin SWF loaded successfully.")
      listener.handleSkinSWFLoaded(swf)
    }
  }
}
