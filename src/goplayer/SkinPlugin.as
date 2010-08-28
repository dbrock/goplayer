package goplayer
{
  import flash.display.LoaderInfo

  public class SkinPlugin
  {
    private var info : LoaderInfo

    public function SkinPlugin(info : LoaderInfo)
    {
      this.info = info

      if (!(info.content is SkinSWF))
        debug("Error: Skin SWF must implement " + interfaceName)
    }

    private function get interfaceName() : String
    { return getQualifiedClassName(SkinSWF) }

    public function getSkin() : WrappedSkin
    {
      try
        { return $getSkin() }
      catch (error : Error)
        { debug("Error: " + error.message)}

      return null
    }

    private function $getSkin() : WrappedSkin
    {
      else
        return new WrappedSkin(SkinSWF(info.content).getSkin())
    }
  }
}
