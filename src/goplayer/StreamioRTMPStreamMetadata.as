package goplayer
{
  public class StreamioRTMPStreamMetadata
    implements RTMPStreamMetadata
  {
    private var json : Object
    private var movieMetadata : StreamioMovieMetadata

    public function StreamioRTMPStreamMetadata
      (json : Object, movieMetadata : StreamioMovieMetadata)
    { this.json = json, this.movieMetadata = movieMetadata }

    public function get url() : URL
    { return URL.parse("rtmp://" + json.rtmp_uri) }

    public function get name() : String
    { return json.rtmp_stream_uri }

    public function get dimensions() : Dimensions
    { return new Dimensions(json.width, json.height) }

    public function get duration() : Duration
    { return movieMetadata.duration }

    public function dump() : void
    {
      debug("Streamio RTMP stream metadata:")

      for (var property : String in json)
        debug("  " + property + ": " + json[property])
    }
  }
}
