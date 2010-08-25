package goplayer
{
  import flash.display.DisplayObject

  public function setDimensions
    (object : DisplayObject, dimensions : Dimensions) : void
  {
    object.width = dimensions.width
    object.height = dimensions.height
  }
}
