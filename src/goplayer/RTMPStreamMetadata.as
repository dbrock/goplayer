package goplayer
{
  public interface RTMPStreamMetadata
  {
    function get url() : URL
    function get name() : String
    function get dimensions() : Dimensions
    function get duration() : Duration

    function dump() : void
  }
}
