package goplayer
{
  public class StreamioTranscoding implements RTMPStream
  {
    private var json : Object

    public function StreamioTranscoding(json : Object)
    { this.json = json }

    public function get rtmpURL() : URL
    {
      // Always try port 443 first.  If this fails, the player will
      // fall back to trying all the standard ports and protocols.
      return json.rtmp_base_uri ? $rtmpURL.withPort(443) : null
    }

    private function get $rtmpURL() : URL
    { return URL.parse("rtmp://" + json.rtmp_base_uri) }

    public function get httpURL() : URL
    { return URL.parse("http://" + json.http_uri) }

    public function get name() : String
    { return json.rtmp_stream_uri }

    public function get bitrate() : Bitrate
    { return Bitrate.kbps(json.bitrate) }

    public function get dimensions() : Dimensions
    { return new Dimensions(json.width, json.height) }
  }
}
