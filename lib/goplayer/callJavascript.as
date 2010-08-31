package goplayer
{
  import flash.external.ExternalInterface

  public function callJavascript(... rest : Array) : *
  { return ExternalInterface.call.apply(ExternalInterface, rest) }
}
