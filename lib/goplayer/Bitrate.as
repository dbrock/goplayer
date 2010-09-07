package goplayer
{
  public class Bitrate
  {
    private var _kbps : Number

    public function Bitrate(kbps : Number)
    { _kbps = kbps }

    public function get kbps() : Number
    { return _kbps }

    public function scaledBy(scalar : Number) : Bitrate
    { return Bitrate.kbps(kbps * scalar) }

    public function isLessThan(other : Bitrate) : Boolean
    { return kbps < other.kbps }

    public function isGreaterThan(other : Bitrate) : Boolean
    { return kbps > other.kbps }

    public function toString() : String
    {
      if (kbps > 1024)
        return (kbps / 1024).toFixed(1) + "Mbps"
      else
        return Math.round(kbps) + "kbps"
    }

    public static function kbps(value : Number) : Bitrate
    { return new Bitrate(value) }

    public static const ZERO : Bitrate = new Bitrate(0)

    public static function parse(input : String) : Bitrate
    {
      const match : Array = input.match(/^((\d*\.)?\d+)kbps$/)

      return match == null ? null : Bitrate.kbps(parseFloat(match[1]))
    }
  }
}
