package goplayer
{
  import flash.display.DisplayObject
  import flash.events.MouseEvent

  public function onrollover
    (object : DisplayObject, callback : Function) : void
  { addNullaryEventListener(object, MouseEvent.ROLL_OVER, callback) }
}
