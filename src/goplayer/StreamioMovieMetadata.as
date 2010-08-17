package goplayer
{
  public class StreamioMovieMetadata implements MovieMetadata
  {
    private var json : Object

    public function StreamioMovieMetadata(json : Object)
    { this.json = json }

    public function get title() : String
    { return json.title }

    public function get duration() : Duration
    { return Duration.seconds(json.duration) }

    public function get rtmpStreams() : Array
    {
      const result : Array = []

      for each (var transcoding : Object in json.transcodings)
        result.push(new StreamioRTMPStreamMetadata(transcoding, this))

      return result
    }

    public function dump() : void
    {
      debug("Streamio movie metadata:")

      for (var property : String in json)
        debug("  " + property + ": " + json[property])
    }
  }
}
