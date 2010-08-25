package goplayer
{
  public class Position
  {
    private var _x : Number
    private var _y : Number

    public function Position(x : Number, y : Number)
    { _x = x, _y = y }

    public function get x() : Number
    { return _x }

    public function get y() : Number
    { return _y }

    public function plus(other : Dimensions) : Position
    { return new Position(x + other.width, y + other.height) }

    public function minus(other : Dimensions) : Position
    { return new Position(x - other.width, y - other.height) }

    public static const ZERO : Position = new Position(0, 0)
  }
}
