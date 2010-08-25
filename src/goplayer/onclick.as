package goplayer
{
  import flash.display.DisplayObject
  import flash.events.MouseEvent

  public function onclick(object : DisplayObject, callback : Function) : void
  {
    object.addEventListener(MouseEvent.CLICK,
      function (event : MouseEvent) : void { callback() })
  }
}
