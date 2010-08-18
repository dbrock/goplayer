package goplayer
{
  import flash.external.ExternalInterface

  public class ExternalLogger implements Logger
  {
    private var functionName : String

    public function ExternalLogger(functionName : String)
    { this.functionName = functionName }

    public function log(message : String) : void
    { ExternalInterface.call(functionName, message) }

    public static function get available() : Boolean
    { return ExternalInterface.available }
  }
}
