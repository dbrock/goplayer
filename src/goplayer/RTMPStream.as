package goplayer
{
  public interface RTMPStream
  {
    function get name() : String
    function get bitrate() : uint
    function get dimensions() : Dimensions
  }
}
