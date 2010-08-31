package goplayer
{
  import flash.display.DisplayObject
  import flash.events.MouseEvent

  public function onrollout
    (object : DisplayObject, callback : Function) : void
  { addNullaryEventListener(object, MouseEvent.ROLL_OUT, callback) }
}
