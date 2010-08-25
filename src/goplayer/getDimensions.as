package goplayer
{
  import flash.display.DisplayObject

  public function getDimensions(object : DisplayObject) : Dimensions
  { return new Dimensions(object.width, object.height) }
}
