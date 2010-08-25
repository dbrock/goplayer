package goplayer
{
  import flash.display.LoaderInfo

  public class Skin
  {
    private var info : LoaderInfo

    public function Skin(info : LoaderInfo)
    { this.info = info }

    public function getClass(name : String) : Class
    {
      if (!info.applicationDomain.hasDefinition(name))
        debug("Error: Skin component not found: " + name)

      return Class(info.applicationDomain.getDefinition(name))
    }

    public function instantiate(name : String) : *
    { return new (getClass(name)) }
  }
}
