package goplayer
{
  public class Dimensions
  {
    public var _width : Number
    public var _height : Number

    public function Dimensions(width : Number, height : Number)
    { _width = width, _height = height }

    public function get width() : Number
    { return _width }

    public function get height() : Number
    { return _height }

    public function get doubled() : Dimensions
    { return new Dimensions(width * 2, height * 2) }

    public function plus(other : Dimensions) : Dimensions
    { return new Dimensions(width + other.width, height + other.height) }
  }
}
