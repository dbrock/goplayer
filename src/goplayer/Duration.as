package goplayer
{
  public class Duration
  {
    private var _seconds : Number

    public function Duration(seconds : Number)
    { _seconds = seconds }

    public function get seconds() : Number
    { return _seconds }

    public function toString() : String
    { return seconds.toFixed(1) + "s" }
    
    public function plus(other : Duration) : Duration
    { return Duration.seconds(seconds + other.seconds) }
    
    public function minus(other : Duration) : Duration
    { return Duration.seconds(seconds - other.seconds) }

    public static function seconds(value : Number) : Duration
    { return new Duration(value) }

    public static function milliseconds(value : Number) : Duration
    { return new Duration(value / 1000) }

    public static const ZERO : Duration = new Duration(0)
  }
}
