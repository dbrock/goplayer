package goplayer
{
  public interface MovieMetadata
  {
    function get title() : String
    function get rtmpStreams() : Array
    function get duration() : Duration
  }
}
