package goplayer
{
  import flash.display.DisplayObject
  import flash.events.Event

  public function addNullaryEventListener
    (object : DisplayObject, type : String, callback : Function) : void
  {
    object.addEventListener(type,
      function (event : Event) : void { callback() })
  }
}
