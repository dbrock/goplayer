package goplayer
{
  import org.asspec.util.sequences.Sequence

  public class StreamioMovieMetadata implements MovieMetadata
  {
    private var json : Object

    public function StreamioMovieMetadata(json : Object)
    { this.json = json }

    public function get title() : String
    { return json.title }

    public function get duration() : Duration
    { return Duration.seconds(json.duration) }

    public function get rtmpStreams() : Sequence
    {
      const self : StreamioMovieMetadata = this

      return Sequence.fromArray(json.transcodings).map(
        function (transcoding : Object) : Object
        { return new StreamioRTMPStreamMetadata(transcoding, self) })
    }

    public function dump() : void
    {
      debug("Streamio movie metadata:")

      for (var property : String in json)
        debug("  " + property + ": " + json[property])
    }
  }
}
