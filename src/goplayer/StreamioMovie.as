package goplayer
{
  public class StreamioMovie
    implements Movie
  {
    private var json : Object

    public function StreamioMovie(json : Object)
    { this.json = json }

    public function get title() : String
    { return json.title }

    public function get duration() : Duration
    { return Duration.seconds(json.duration) }

    public function get aspectRatio() : Number
    { return json.aspect_ratio_multiplier }

    public function get imageURL() : URL
    { return URL.parse("http://" + json.screenshot.normal) }

    public function get rtmpURL() : URL
    {
      if (rtmpStreams.length == 0)
        return null
      else
        return StreamioRTMPStream(rtmpStreams[0]).url
    }

    public function get rtmpStreams() : Array
    {
      const result : Array = []

      for each (var transcoding : Object in json.transcodings)
        result.push(new StreamioRTMPStream(transcoding))

      return result
    }

    public function dump() : void
    {
      debug("Streamio movie:")

      for (var property : String in json)
        debug("  " + property + ": " + json[property])
    }
  }
}
