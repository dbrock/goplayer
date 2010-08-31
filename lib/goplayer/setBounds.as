package goplayer
{
  import flash.display.DisplayObject

  public function setBounds
    (object : DisplayObject,
     position : Position,
     dimensions : Dimensions) : void
  {
    setPosition(object, position)
    setDimensions(object, dimensions)
  }
}
