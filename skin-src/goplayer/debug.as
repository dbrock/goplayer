package goplayer
{
	public function debug(message : Object)
  { callJavascript("goplayer.log", message.toString()) }
}
