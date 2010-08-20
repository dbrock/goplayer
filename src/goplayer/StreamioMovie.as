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
    {
      if (json.image)
        return URL.parse("http://" + json.image.normal)
      else if (json.screenshot)
        return URL.parse("http://" + json.screenshot.normal)
      else
        return null
    }

    public function get httpURL() : URL
    { return hasTranscodings ? bestTranscoding.httpURL : null }

    public function get rtmpURL() : URL
    { return hasTranscodings ? bestTranscoding.rtmpURL : null }

    public function get rtmpStreams() : Array
    { return transcodings }

    private function get hasTranscodings() : Boolean
    { return transcodings.length > 0 }

    private function get bestTranscoding() : StreamioTranscoding
    {
      var result : StreamioTranscoding = transcodings[0]

      for each (var transcoding : StreamioTranscoding in transcodings)
        if (transcoding.bitrate.isGreaterThan(result.bitrate))
          result = transcoding
      
      return result
    }

    private function get transcodings() : Array
    {
      const result : Array = []

      for each (var transcoding : Object in json.transcodings)
        result.push(new StreamioTranscoding(transcoding))

      return result
    }
  }
}
