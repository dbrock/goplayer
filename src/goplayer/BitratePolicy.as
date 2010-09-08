package goplayer
{
  public class BitratePolicy
  {
    private var _bitrate : Bitrate

    public function BitratePolicy(bitrate : Bitrate = null)
    { _bitrate = bitrate }

    public function get bitrate() : Bitrate
    { return _bitrate }

    public function toString() : String
    {
      return this == MAX ? "maximum bitrate"
        : this == MIN ? "minimum bitrate"
        : this == BEST ? "most appropriate bitrate"
        : "highest bitrate not exceeding " + bitrate
    }

    public static const MAX : BitratePolicy = new BitratePolicy
    public static const MIN : BitratePolicy = new BitratePolicy
    public static const BEST : BitratePolicy = new BitratePolicy

    public static function specific(bitrate : Bitrate) : BitratePolicy
    { return new BitratePolicy(bitrate) }
  }
}
