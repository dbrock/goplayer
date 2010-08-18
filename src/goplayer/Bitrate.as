package goplayer
{
  public class Bitrate
  {
    private var _kbps : Number

    public function Bitrate(kbps : Number)
    { _kbps = kbps }

    public function get kbps() : Number
    { return _kbps }

    public function toString() : String
    { return kbps.toFixed(1) + "kbps" }

    public static function kbps(value : Number) : Bitrate
    { return new Bitrate(value) }

    public static const ZERO : Bitrate = new Bitrate(0)
  }
}
