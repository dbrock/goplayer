package goplayer
{
  public class Player
    implements FlashNetConnectionListener, FlashNetStreamListener
  {
    private const DEFAULT_VOLUME : Number = .8

    private const START_BUFFER : Duration = Duration.seconds(.1)
    private const SMALL_BUFFER : Duration = Duration.seconds(3)
    private const LARGE_BUFFER : Duration = Duration.seconds(60)

    private const finishingListeners : Array = []

    private var _movie : Movie
    private var connection : FlashNetConnection

    private var triedStandardRTMP : Boolean = false
    private var rtmpAvailable : Boolean = false

    private var measuredBandwidth : Bitrate = null
    private var measuredLatency : Duration = null

    private var stream : FlashNetStream = null
    private var metadata : Object = null

    private var _volume : Number = DEFAULT_VOLUME
    private var _paused : Boolean = false
    private var _buffering : Boolean = false

    public function Player
      (movie : Movie, connection : FlashNetConnection)
    {
      _movie = movie, this.connection = connection

      connection.listener = this
    }

    public function get movie() : Movie
    { return _movie }

    public function addFinishingListener
      (value : PlayerFinishingListener) : void
    { finishingListeners.push(value) }

    // -----------------------------------------------------

    public function start() : void
    {
      if (movie.rtmpURL)
        connectUsingRTMP()
      else
        connectUsingHTTP()
    }

    public function handleConnectionFailed() : void
    {
      if (movie.rtmpURL.hasPort && !triedStandardRTMP)
        handleCustomRTMPUnavailable()
      else
        handleRTMPUnavailable()
    }

    private function handleCustomRTMPUnavailable() : void
    {
      debug("Trying to connect using default RTMP ports.")
      connectUsingStandardRTMP()
    }

    private function handleRTMPUnavailable() : void
    {
      debug("Could not connect using RTMP; trying plain HTTP.")
      connectUsingHTTP()
    }

    private function connectUsingRTMP() : void
    { connection.connect(movie.rtmpURL) }

    private function connectUsingStandardRTMP() : void
    {
      triedStandardRTMP = true
      connection.connect(movie.rtmpURL.withoutPort)
    }

    private function connectUsingHTTP() : void
    {
      rtmpAvailable = false
      connection.dontConnect()
      startPlaying()
    }

    public function handleConnectionClosed() : void
    {}

    // -----------------------------------------------------

    public function handleConnectionEstablished() : void
    {
      rtmpAvailable = true
      connection.determineBandwidth()
    }

    public function handleBandwidthDetermined
      (bandwidth : Bitrate, latency : Duration) : void
    {
      measuredBandwidth = bandwidth
      measuredLatency = latency

      startPlaying()
    }

    private function startPlaying() : void
    {
      stream = connection.getNetStream()
      stream.listener = this
      stream.volume = volume

      useStartBuffer()

      if (rtmpAvailable)
        playRTMPStream()
      else
        playHTTPStream()

      if (paused)
        stream.paused = true
    }

    private function playRTMPStream() : void
    { stream.playRTMP(bestStream, streams) }

    private function playHTTPStream() : void
    { stream.playHTTP(movie.httpURL) }

    private function get bestStream() : RTMPStream
    { return new RTMPStreamPicker(streams, maxBitrate).bestStream }

    private function get streams() : Array
    { return movie.rtmpStreams }

    private function get maxBitrate() : Bitrate
    { return measuredBandwidth.scaledBy(.8) }

    // -----------------------------------------------------
    
    public function handleNetStreamMetadata(data : Object) : void
    { metadata = data }

    public function handleStreamingStarted() : void
    {
      useStartBuffer()
      _buffering = true
    }

    public function handleBufferFilled() : void
    { handleBufferingFinished() }

    private function handleBufferingFinished() : void
    {
      _buffering = false

      // Make sure to let playback resume first.
      later(useLargeBuffer)
    }

    public function handleBufferEmptied() : void
    {
      if (finishedPlaying)
        handleFinishedPlaying()
      else
        handleBufferingStarted()
    }

    private function handleBufferingStarted() : void
    {
      useSmallBuffer()
      _buffering = true
    }

    private function useStartBuffer() : void
    { stream.bufferTime = START_BUFFER }

    private function useSmallBuffer() : void
    { stream.bufferTime = SMALL_BUFFER }

    private function useLargeBuffer() : void
    { stream.bufferTime = LARGE_BUFFER }

    public function get buffering() : Boolean
    { return _buffering }

    public function handleStreamingStopped() : void
    {
      if (finishedPlaying)
        handleFinishedPlaying()
    }

    private function handleFinishedPlaying() : void
    {
      debug("Finished playing.")

      for each (var listener : PlayerFinishingListener in finishingListeners)
        listener.handleMovieFinishedPlaying()
    }

    private function get finishedPlaying() : Boolean
    { return timeRemaining.seconds < 1 }

    private function get timeRemaining() : Duration
    { return streamLength.minus(playheadPosition) }

    // -----------------------------------------------------

    public function get paused() : Boolean
    { return _paused }

    public function set paused(value : Boolean) : void
    {
      _paused = value

      if (stream)
        stream.paused = value
    }

    public function togglePaused() : void
    { paused = !paused }

    // -----------------------------------------------------

    public function get playheadPosition() : Duration
    { return stream ? stream.playheadPosition : Duration.ZERO }

    public function set playheadPosition(value : Duration) : void
    {
      useStartBuffer()
      stream.playheadPosition = value
    }

    public function seekBy(delta : Duration) : void
    { playheadPosition = playheadPosition.plus(delta) }

    public function rewind() : void
    { playheadPosition = Duration.ZERO }

    // -----------------------------------------------------

    public function get volume() : Number
    { return _volume }

    public function set volume(value : Number) : void
    {
      _volume = value

      if (stream)
        stream.volume = value
    }

    public function changeVolumeBy(delta : Number) : void
    { volume = volume + delta }

    // -----------------------------------------------------

    public function get aspectRatio() : Number
    { return movie.aspectRatio }

    public function get bufferTime() : Duration
    { return stream ? stream.bufferTime : Duration.ZERO }

    public function get bufferLength() : Duration
    { return stream ? stream.bufferLength : Duration.ZERO }

    public function get bufferFillRatio() : Number
    { return Math.min(1, bufferLength.seconds / bufferTime.seconds) }

    public function get streamLength() : Duration
    {
      return metadata
        ? Duration.seconds(metadata.duration)
        : movie.duration
    }

    public function get currentBitrate() : Bitrate
    { return stream ? stream.bitrate : Bitrate.ZERO }

    public function get currentBandwidth() : Bitrate
    { return stream ? stream.bandwidth : Bitrate.ZERO }

    public function get highQualityDimensions() : Dimensions
    {
      var result : Dimensions = Dimensions.ZERO

      for each (var stream : RTMPStream in movie.rtmpStreams)
        if (stream.dimensions.isGreaterThan(result))
          result = stream.dimensions

      return result
    }
  }
}
