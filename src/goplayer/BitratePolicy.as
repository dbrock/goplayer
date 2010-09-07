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

    public static function parse(input : String) : BitratePolicy
    {
      if (input == "max")
        return MAX
      else if (input == "min")
        return MIN
      else if (input == "best")
        return BEST
      else if (Bitrate.parse(input))
        return specific(Bitrate.parse(input))
      else
        debug("Error: Invalid bitrate policy: “" + input + "”")

      return null
    }
  }
}
