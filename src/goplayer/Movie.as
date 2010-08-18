package goplayer
{
  public interface Movie
  {
    function get title() : String
    function get rtmpURL() : URL
    function get rtmpStreams() : Array
    function get duration() : Duration
  }
}
