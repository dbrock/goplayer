package goplayer
{
  import flash.display.DisplayObject

  public function setPosition
    (object : DisplayObject, position : Position) : void
  {
    object.x = position.x
    object.y = position.y
  }
}
