package goplayer
{
  public class RTMPStreamPicker
  {
    private var streams : Array
    private var maxBitrate : Bitrate

    public function RTMPStreamPicker
      (streams : Array, maxBitrate : Bitrate)
    { this.streams = streams, this.maxBitrate = maxBitrate }

    public function get bestStream() : RTMPStream
    {
      if (maxBitrate == null)
        return highEndStream
      else
        return $bestStream
    }

    private function get $bestStream() : RTMPStream
    {
      var result : RTMPStream = lowEndStream

      for each (var stream : RTMPStream in goodStreams)
        if (stream.bitrate.isGreaterThan(result.bitrate))
          result = stream

      return result
    }

    private function get lowEndStream() : RTMPStream
    {
      var result : RTMPStream = streams[0]

      for each (var stream : RTMPStream in streams)
        if (stream.bitrate.isLessThan(result.bitrate))
          result = stream

      return result
    }

    private function get highEndStream() : RTMPStream
    {
      var result : RTMPStream = streams[0]

      for each (var stream : RTMPStream in streams)
        if (stream.bitrate.isGreaterThan(result.bitrate))
          result = stream

      return result
    }

    private function get goodStreams() : Array
    {
      const result : Array = []

      for each (var stream : RTMPStream in streams)
        if (stream.bitrate.isLessThan(maxBitrate))
          result.push(stream)

      return result
    }
  }
}
