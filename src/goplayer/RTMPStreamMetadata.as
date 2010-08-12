package goplayer
{
  public interface RTMPStreamMetadata
  {
    function get url() : String
    function get name() : String
    function get dimensions() : Dimensions
    function get duration() : Number

    function dump() : void
  }
}
