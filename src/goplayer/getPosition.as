package goplayer
{
  import flash.display.DisplayObject

  public function getPosition(object : DisplayObject) : Position
  { return new Position(object.x, object.y) }
}
