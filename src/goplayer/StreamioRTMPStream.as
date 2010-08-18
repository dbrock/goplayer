package goplayer
{
  public class StreamioRTMPStream implements RTMPStream
  {
    private var json : Object

    public function StreamioRTMPStream(json : Object)
    { this.json = json }

    public function get url() : URL
    { return URL.parse("rtmp://" + json.rtmp_base_uri).withPort(443) }

    public function get name() : String
    { return json.rtmp_stream_uri }

    public function get bitrate() : uint
    { return json.bitrate }

    public function get dimensions() : Dimensions
    { return new Dimensions(json.width, json.height) }
  }
}
