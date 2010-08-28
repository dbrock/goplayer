package goplayer
{
  import flash.display.LoaderInfo

  public class Plugin
  {
    private var info : LoaderInfo

    public function Plugin(info : LoaderInfo)
    { this.info = info }

    public function getClass(name : String) : Class
    {
      if (!info.applicationDomain.hasDefinition(name))
        debug("Error: Missing class in plugin: " + name)

      return Class(info.applicationDomain.getDefinition(name))
    }

    public function instantiate(name : String) : *
    { return new (getClass(name)) }
  }
}
