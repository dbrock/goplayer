package goplayer
{
  public class RTMPStreamPicker
  {
    // Max bitrate as a fraction of the measured bandwidth.
    public static const BANDWIDTH_FRACTION : Number = .8

    private var streams : Array
    private var policy : BitratePolicy
    private var bandwidth : Bitrate

    public function RTMPStreamPicker
      (streams : Array,
       policy : BitratePolicy,
       bandwidth : Bitrate)
    {
      this.streams = streams
      this.policy = policy
      this.bandwidth = bandwidth
    }

    public function get first() : RTMPStream
    {
      if (policy == BitratePolicy.MAX)
        return highEndStream
      else if (policy == BitratePolicy.MIN)
        return lowEndStream
      else if (policy == BitratePolicy.BEST)
        return bestStream
      else
        return specificStream
    }

    public function get all() : Array
    { return policy == BitratePolicy.BEST ? streams : [first] }

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

    private function get bestStream() : RTMPStream
    {
      var result : RTMPStream = lowEndStream

      for each (var stream : RTMPStream in goodStreams)
        if (stream.bitrate.isGreaterThan(result.bitrate))
          result = stream

      return result
    }

    private function get goodStreams() : Array
    { return bandwidth == null ? streams : $goodStreams }

    private function get $goodStreams() : Array
    {
      const result : Array = []

      for each (var stream : RTMPStream in streams)
        if (stream.bitrate.isLessThan(maxBitrate))
          result.push(stream)

      return result
    }

    private function get maxBitrate() : Bitrate
    { return bandwidth.scaledBy(BANDWIDTH_FRACTION) }

    private function get specificStream() : RTMPStream
    {
      var result : RTMPStream = lowEndStream

      for each (var stream : RTMPStream in streams)
        if (!stream.bitrate.isGreaterThan(policy.bitrate)
            && stream.bitrate.isGreaterThan(result.bitrate))
          result = stream

      return result
    }
  }
}
