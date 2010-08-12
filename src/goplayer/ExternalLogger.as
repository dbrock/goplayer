package goplayer
{
  import flash.external.ExternalInterface

  public class ExternalLogger implements Logger
  {
    public function log(message : String) : void
    { ExternalInterface.call("goplayer.log", message) }
  }
}
