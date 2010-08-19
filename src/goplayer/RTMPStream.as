package goplayer
{
  public interface RTMPStream
  {
    function get name() : String
    function get bitrate() : Bitrate
    function get dimensions() : Dimensions
  }
}
