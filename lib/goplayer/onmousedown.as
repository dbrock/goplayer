package goplayer
{
  import flash.display.DisplayObject
  import flash.events.MouseEvent

  public function onmousedown
    (object : DisplayObject, callback : Function) : void
  { addNullaryEventListener(object, MouseEvent.MOUSE_DOWN, callback) }
}
