package goplayer
{
  public class Player
    implements FlashNetConnectionListener, FlashNetStreamListener
  {
    private const DEFAULT_VOLUME : Number = .8

    private var movie : Movie
    private var connection : FlashNetConnection

    private var _listener : PlayerListener = null

    private var connector : RTMPConnector = null
    private var stream : FlashNetStream = null
    private var metadata : Object = null

    private var _volume : Number = DEFAULT_VOLUME
    private var _paused : Boolean = false

    public function Player
      (movie : Movie,
       connection : FlashNetConnection)
    {
      this.movie = movie
      this.connection = connection

      connection.listener = this
    }

    public function set listener(value : PlayerListener) : void
    { _listener = value }

    // -----------------------------------------------------

    public function start() : void
    {
      connector = new RTMPConnector(connection, movie.rtmpURL)
      connector.tryNextPort()
    }

    public function handleConnectionFailed() : void
    {
      if (connector.hasMoreIdeas)
        connector.tryNextPort()
      else
        debug("Tried all alternative ports; giving up.")
    }

    public function handleConnectionClosed() : void
    {}

    // -----------------------------------------------------

    public function handleConnectionEstablished() : void
    {
      stream = connection.getNetStream()
      stream.listener = this

      stream.bufferTime = Duration.seconds(5)
      stream.volume = volume

      stream.play(movie.rtmpStreams)

      if (paused)
        stream.paused = true
    }

    public function handleNetStreamMetadata(data : Object) : void
    { metadata = data }

    public function handleStreamingStopped() : void
    { handleMaybeFinishedPlaying() }

    public function handleBufferEmptied() : void
    { handleMaybeFinishedPlaying() }

    private function handleMaybeFinishedPlaying() : void
    {
      if (finishedPlaying)
        handleFinishedPlaying()
    }

    private function handleFinishedPlaying() : void
    {
      debug("Finished playing.")
      _listener.handleMovieFinishedPlaying()
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

    public function get streamLength() : Duration
    {
      return metadata
        ? Duration.seconds(metadata.duration)
        : movie.duration
    }
  }
}
