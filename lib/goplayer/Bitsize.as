package goplayer
{
  public class Bitsize
  {
    private var _bytes : Number

    public function Bitsize(bytes : Number)
    { _bytes = bytes }

    public function get bytes() : Number
    { return _bytes }

    public function get kilobytes() : Number
    { return bytes / 1024 }

    public function get megabytes() : Number
    { return kilobytes / 1024 }

    public function get gigabytes() : Number
    { return megabytes / 1024 }

    public function toString() : String
    {
      if (gigabytes > 1)
        return gigabytes.toFixed(1) + "GB"
      else if (megabytes > 1)
        return megabytes.toFixed(1) + "MB"
      else if (kilobytes > 1)
        return kilobytes.toFixed(1) + "kB"
      else
        return bytes.toFixed(0) + "B"
    }

    public static function bytes(value : Number) : Bitsize
    { return new Bitsize(value) }
  }
}
