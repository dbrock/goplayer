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

    public function scaledBy(scalar : Number) : Duration
    { return Duration.seconds(seconds * scalar) }

    public function dividedBy(other : Duration) : Number
    { return seconds / other.seconds }

    public static function equals(a : Duration, b : Duration) : Boolean
    { return a == null ? b == null : b != null && a.seconds == b.seconds }

    public function get mss() : String
    { return m + ":" + ss }

    private function get m() : String
    { return Math.floor(minutes).toString() }

    private function get ss() : String
    { return pad(seconds - Math.floor(minutes) * 60) }

    private function get minutes() : Number
    { return seconds / 60 }

    private function pad(value : Number) : String
    { return $pad(Math.round(value)) }

    private function $pad(value : Number) : String
    { return value < 10 ? "0" + value : value.toString() }

    public static function seconds(value : Number) : Duration
    { return new Duration(value) }

    public static function milliseconds(value : Number) : Duration
    { return new Duration(value / 1000) }

    public static const ZERO : Duration = new Duration(0)
  }
}
