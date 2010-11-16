package goplayer
{
  import flash.utils.getTimer
  
  public class Player implements
    FlashNetConnectionListener,
    FlashNetStreamListener
  {
    private const DEFAULT_VOLUME : Number = .8

    private const START_BUFFER : Duration = Duration.seconds(3)
    private const SMALL_BUFFER : Duration = Duration.seconds(5)
    private const LARGE_BUFFER : Duration = Duration.seconds(60)
    private const SEEK_GRACE_TIME : Duration = Duration.seconds(2)

    private const finishingListeners : Array = []

    private var connection : FlashNetConnection
    private var _movie : Movie
    private var bitratePolicy : BitratePolicy
    private var enableRTMP : Boolean
    private var reporter : MovieEventReporter
    private var sharedVolumeVariable : SharedVariable

    private var _started : Boolean = false
    private var _finished : Boolean = false
    private var triedStandardRTMP : Boolean = false
    private var _usingRTMP : Boolean = false

    private var measuredBandwidth : Bitrate = null
    private var measuredLatency : Duration = null

    private var stream : FlashNetStream = null
    private var metadata : Object = null

    private var _volume : Number = NaN
    private var savedVolume : Number = 0
    private var _paused : Boolean = false
    private var _buffering : Boolean = false
    private var seekStopwatch : Stopwatch = new Stopwatch

    public function Player
      (connection : FlashNetConnection,
       movie : Movie,
       bitratePolicy : BitratePolicy,
       enableRTMP : Boolean,
       reporter : MovieEventReporter,
       sharedVolumeVariable : SharedVariable)
    {
      this.connection = connection
      _movie = movie
      this.bitratePolicy = bitratePolicy
      this.enableRTMP = enableRTMP
      this.reporter = reporter
      this.sharedVolumeVariable = sharedVolumeVariable

      connection.listener = this

      reporter.reportMovieViewed(movie.id)

      if (sharedVolumeVariable.hasValue)
        volume = sharedVolumeVariable.value
      else
        volume = DEFAULT_VOLUME
    }

    public function get movie() : Movie
    { return _movie }

    public function addFinishingListener
      (value : PlayerFinishingListener) : void
    { finishingListeners.push(value) }

    public function get started() : Boolean
    { return _started }

    public function get running() : Boolean
    { return started && !finished }

    public function get finished() : Boolean
    { return _finished }

    // -----------------------------------------------------

    public function destroy() : void
    {
      if (stream != null)
        stream.destroy()
    }

    public function start() : void
    {
      _started = true

      if (enableRTMP && movie.rtmpURL != null)
        connectUsingRTMP()
      else
        connectUsingHTTP()
        
      reporter.reportMoviePlayed(movie.id)
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

    public function get usingRTMP() : Boolean
    { return _usingRTMP }

    private function connectUsingRTMP() : void
    { connection.connect(movie.rtmpURL) }

    private function connectUsingStandardRTMP() : void
    {
      triedStandardRTMP = true
      connection.connect(movie.rtmpURL.withoutPort)
    }

    private function connectUsingHTTP() : void
    {
      _usingRTMP = false
      connection.dontConnect()
      startPlaying()
    }

    public function handleConnectionClosed() : void
    {}

    // -----------------------------------------------------

    public function handleConnectionEstablished() : void
    {
      _usingRTMP = true

      if (bandwidthDeterminationNeeded)
        connection.determineBandwidth()
      else
        startPlaying()
    }

    private function get bandwidthDeterminationNeeded() : Boolean
    { return bitratePolicy == BitratePolicy.BEST }

    public function handleBandwidthDetermined
      (bandwidth : Bitrate, latency : Duration) : void
    {
      measuredBandwidth = bandwidth
      measuredLatency = latency

      startPlaying()
    }

    private function get bandwidthDetermined() : Boolean
    { return measuredBandwidth != null }

    private function startPlaying() : void
    {
      stream = connection.getNetStream()
      stream.listener = this
      stream.volume = volume

      useStartBuffer()

      if (usingRTMP)
        playRTMPStream()
      else
        playHTTPStream()

      if (paused)
        stream.paused = true
    }

    private function playRTMPStream() : void
    { stream.playRTMP(streamPicker.first, streamPicker.all) }

    private function playHTTPStream() : void
    { stream.playHTTP(movie.httpURL) }

    private function get streamPicker() : RTMPStreamPicker
    {
      return new RTMPStreamPicker
        (movie.rtmpStreams, bitratePolicy, measuredBandwidth)
    }

    // -----------------------------------------------------
    
    public function handleNetStreamMetadata(data : Object) : void
    {
      metadata = data

      if (!usingRTMP)
        debug("Video file size: " + stream.httpFileSize)
    }

    public function handleStreamingStarted() : void
    {
      useStartBuffer()
      _buffering = true
      _finished = false
    }

    public function handleBufferFilled() : void
    { handleBufferingFinished() }

    private function handleBufferingFinished() : void
    {
      _buffering = false

      // Give the backend a chance to resume playback before we go
      // ahead and raise the buffer size further.
      later($handleBufferingFinished)
    }

    private function $handleBufferingFinished() : void
    {
      // Make sure playback was not interrupted.
      if (!buffering && !finished)
        useLargeBuffer()
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
      _finished = false
    }

    private function useStartBuffer() : void
    { stream.bufferTime = START_BUFFER }

    private function useSmallBuffer() : void
    { stream.bufferTime = SMALL_BUFFER }

    private function useLargeBuffer() : void
    { stream.bufferTime = LARGE_BUFFER }

    public function get buffering() : Boolean
    { return _buffering }

    public function get bufferingUnexpectedly() : Boolean
    { return buffering && !justSeeked }

    private function get justSeeked() : Boolean
    { return seekStopwatch.within(SEEK_GRACE_TIME) }

    public function handleStreamingStopped() : void
    {
      _buffering = false

      if (finishedPlaying)
        handleFinishedPlaying()
    }

    private function handleFinishedPlaying() : void
    {
      debug("Finished playing.")
      _finished = true

      for each (var listener : PlayerFinishingListener in finishingListeners)
        listener.handleMovieFinishedPlaying()
    }

    public function stop() : void
    {
      debug("Stopping.")
      stream.close()
      _started = false
      stream = null
      metadata = null
    }

    private function get finishedPlaying() : Boolean
    { return timeRemaining.seconds < 1 }

    private function get timeRemaining() : Duration
    { return duration.minus(currentTime) }

    // -----------------------------------------------------

    public function get paused() : Boolean
    { return _paused }

    public function set paused(value : Boolean) : void
    {
      if (stream != null)
        _paused = value, stream.paused = value
    }

    public function togglePaused() : void
    {
      if (stream != null)
        paused = !paused
    }

    // -----------------------------------------------------

    public function get currentTime() : Duration
    {
      return stream != null && stream.currentTime != null
        ? stream.currentTime : Duration.ZERO
    }

    public function get playheadRatio() : Number
    { return getRatio(currentTime.seconds, duration.seconds) }

    public function get bufferRatio() : Number
    { return getRatio(bufferPosition.seconds, duration.seconds) }

    private function getRatio
      (numerator : Number, denominator : Number) : Number
    { return Math.min(1, numerator / denominator) }

    private function get bufferPosition() : Duration
    { return currentTime.plus(bufferLength) }

    public function set currentTime(value : Duration) : void
    {
      if (stream != null)
        $currentTime = value
    }

    private function set $currentTime(value : Duration) : void
    {
      _finished = false
      seekStopwatch.start()
      useStartBuffer()
      stream.currentTime = value
    }

    public function set playheadRatio(value : Number) : void
    { currentTime = duration.scaledBy(value) }

    public function seekBy(delta : Duration) : void
    { currentTime = currentTime.plus(delta) }

    public function rewind() : void
    { currentTime = Duration.ZERO }

    public function get playing() : Boolean
    { return started && stream != null && !paused && !finished }

    // -----------------------------------------------------

    public function get volume() : Number
    { return _volume }

    public function set volume(value : Number) : void
    {
      _volume = Math.round(clamp(value, 0, 1) * 100) / 100

      if (sharedVolumeVariable.available)
        sharedVolumeVariable.value = volume

      if (stream)
        stream.volume = volume
    }

    public function changeVolumeBy(delta : Number) : void
    { volume = volume + delta }

    public function mute() : void
    {
      savedVolume = volume
      volume = 0
    }

    public function unmute() : void
    { volume = savedVolume == 0 ? DEFAULT_VOLUME : savedVolume }

    public function get muted() : Boolean
    { return volume == 0 }

    // -----------------------------------------------------

    public function get aspectRatio() : Number
    { return movie.aspectRatio }

    public function get bufferTime() : Duration
    {
      return stream != null && stream.bufferTime != null
        ? stream.bufferTime : START_BUFFER
    }

    public function get bufferLength() : Duration
    {
      return stream != null && stream.bufferLength != null
        ? stream.bufferLength : Duration.ZERO
    }

    public function get bufferFillRatio() : Number
    { return getRatio(bufferLength.seconds, bufferTime.seconds) }

    public function get duration() : Duration
    {
      return metadata != null
        ? Duration.seconds(metadata.duration)
        : movie.duration
    }

    public function get currentBitrate() : Bitrate
    {
      return stream != null && stream.bitrate != null
        ? stream.bitrate : Bitrate.ZERO
    }

    public function get currentBandwidth() : Bitrate
    {
      return stream != null && stream.bandwidth != null
        ? stream.bandwidth : Bitrate.ZERO
    }

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
