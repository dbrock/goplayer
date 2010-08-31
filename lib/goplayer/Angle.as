package goplayer
{
  public class Angle
  {
    private var _radians : Number

    public function Angle(radians : Number)
    { _radians = radians }

    public function get radians() : Number
    { return _radians }

    public function get position() : Position
    { return new Position(Math.cos(radians), Math.sin(radians)) }

    public static function radians(value : Number) : Angle
    { return new Angle(value) }

    public static function ratio(value : Number) : Angle
    { return new Angle(value * Math.PI * 2) }
  }
}
