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

    private var triedConnectingUsingDefaultPorts : Boolean = false
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
    { connection.connect(movie.rtmpURL) }

    public function handleConnectionFailed() : void
    {
      if (movie.rtmpURL.hasPort && !triedConnectingUsingDefaultPorts)
        connectUsingDefaultPorts()
      else
        debug("Could not connect using RTMP; giving up.")
    }

    private function connectUsingDefaultPorts() : void
    {
      debug("Trying to connect using default RTMP ports.")

      triedConnectingUsingDefaultPorts = true
      connection.connect(movie.rtmpURL.withoutPort)
    }

    public function handleConnectionClosed() : void
    {}

    // -----------------------------------------------------

    public function handleConnectionEstablished() : void
    {
      stream = connection.getNetStream()
      stream.listener = this

      stream.bufferTime = START_BUFFER
      stream.volume = volume

      stream.play(movie.rtmpStreams)

      _buffering = true

      if (paused)
        stream.paused = true
    }

    public function handleNetStreamMetadata(data : Object) : void
    { metadata = data }

    public function handleBufferFilled() : void
    { handleBufferingFinished() }

    private function handleBufferingFinished() : void
    {
      useLargeBuffer()
      _buffering = false
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
    { stream.playheadPosition = value }

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

    public function get bitrate() : Bitrate
    { return stream ? stream.bitrate : Bitrate.ZERO }

    public function get bandwidth() : Bitrate
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
