package goplayer
{
  import flash.display.DisplayObject
  import flash.events.MouseEvent

  public function onmousemove
    (object : DisplayObject, callback : Function) : void
  { addNullaryEventListener(object, MouseEvent.MOUSE_MOVE, callback) }
}
