package goplayer
{
  import flash.display.DisplayObject
  import flash.events.Event

  public function onresize
    (object : DisplayObject, callback : Function) : void
  {
    addNullaryEventListener(object, Event.RESIZE, callback)
    callback()
  }
}
