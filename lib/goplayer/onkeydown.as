package goplayer
{
  import flash.display.DisplayObject
  import flash.events.KeyboardEvent

  public function onkeydown
    (object : DisplayObject, callback : Function) : void
  {
    function handler(event : KeyboardEvent) : void
    { callback(new Key(event)) }

    object.addEventListener(KeyboardEvent.KEY_DOWN, handler)
  }
}
