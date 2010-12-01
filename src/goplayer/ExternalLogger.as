package goplayer
{
  import flash.external.ExternalInterface

  public class ExternalLogger implements Logger
  {
    private var name : String

    public function ExternalLogger(name : String)
    { this.name = name }

    public function log(message : String) : void
    { ExternalInterface.call(name, message) }
  }
}
