package goplayer
{
  public interface Movie
  {
    function get id() : String
    function get title() : String
    function get duration() : Duration
    function get aspectRatio() : Number
    function get imageURL() : URL

    function get rtmpURL() : URL
    function get rtmpStreams() : Array

    function get httpURL() : URL
  }
}
