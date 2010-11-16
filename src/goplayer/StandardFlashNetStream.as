package goplayer
{
  import com.adobe.fms.DynamicStream
  import com.adobe.fms.DynamicStreamItem

  import flash.events.AsyncErrorEvent
  import flash.events.NetStatusEvent
  import flash.media.SoundTransform
  import flash.media.Video
  import flash.net.NetConnection

  public class StandardFlashNetStream implements FlashNetStream
  {
    private var stream : DynamicStream

    private var _listener : FlashNetStreamListener

    public function StandardFlashNetStream
      (connection : NetConnection, video : Video)
    {
      stream = new DynamicStream(connection)

      video.attachNetStream(stream)

      stream.addEventListener
        (NetStatusEvent.NET_STATUS, handleNetStreamStatus)
      stream.addEventListener
        (AsyncErrorEvent.ASYNC_ERROR, handleAsyncError)
      stream.client = { onMetaData: handleNetStreamMetadata }
    }

    private function handleNetStreamStatus
      (event : NetStatusEvent) : void
    {
      const code : String = event.info.code

      if (code == STREAMING_STARTED)
        debug("Data streaming started; filling buffer.")
      else if (code == STREAMING_STOPPED)
        debug("Data streaming stopped.")
      else if (code == BUFFER_FILLED)
        debug("Buffer filled; ready for playback.")
      else if (code == BUFFER_EMPTIED)
        debug("Buffer empty; stopping playback.")
      else if (code == PAUSED)
        debug("Playback paused.")
      else if (code == RESUMED)
        debug("Playback resumed.")
      else if (code == SEEKED)
        debug("Seeking complete.")
      else if (code == SWITCHED_STREAM)
        debug("Switched to " + bitrate + " stream.")
      else if (code == BUFFER_FLUSH || code == PLAYLIST_RESET)
        null
      else
        debug("Net stream status: " + code)

      if (code == STREAMING_STARTED)
        _listener.handleStreamingStarted()
      else if (code == BUFFER_FILLED)
        _listener.handleBufferFilled()
      else if (code == BUFFER_EMPTIED)
        _listener.handleBufferEmptied()
      else if (code == STREAMING_STOPPED)
        _listener.handleStreamingStopped()
    }

    private function handleAsyncError(event : AsyncErrorEvent) : void
    { debug("Asynchronuous stream error: " + event.error.message) }

    private function handleNetStreamMetadata(data : Object) : void
    { _listener.handleNetStreamMetadata(data) }

    // -----------------------------------------------------

    public function set listener(value : FlashNetStreamListener) : void
    { _listener = value }

    public function playRTMP(stream : RTMPStream, streams : Array) : void
    {
      debug("Playing " + formatRTMPStream(stream) + ".")
      debug("Stream name: <" + stream.name + ">")

      this.stream.startPlay(getDynamicStreamItem(stream, streams))
    }

    private function formatRTMPStream(stream : RTMPStream) : String
    { return stream.bitrate + " " + stream.dimensions + " RTMP stream" }

    public function playHTTP(url : URL) : void
    {
      debug("Playing HTTP stream: <" + url + ">")
      this.stream.play(url.toString())
    }

    private function getDynamicStreamItem
      (stream : RTMPStream, streams : Array) : DynamicStreamItem
    {
      const result : DynamicStreamItem = new DynamicStreamItem

      for each (var stream : RTMPStream in streams)
        result.addStream(stream.name, stream.bitrate.kbps)

      result.startRate = stream.bitrate.kbps

      return result
    }

    public function get httpFileSize() : Bitsize
    { return Bitsize.bytes(stream.bytesTotal) }

    public function set paused(value : Boolean) : void
    {
      if (value)
        stream.pause()
      else
        stream.resume()
    }

    public function get currentTime() : Duration
    {
      return isNaN(stream.time) ? null
        : Duration.seconds(stream.time)
    }

    public function set currentTime(position : Duration) : void
    { stream.seek(position.seconds) }

    public function get bandwidth() : Bitrate
    {
      return isNaN(stream.maxBandwidth) ? null
        : Bitrate.kbps(stream.maxBandwidth)
    }

    public function get bitrate() : Bitrate
    {
      return isNaN(stream.currentStreamBitRate) ? null
        : Bitrate.kbps(stream.currentStreamBitRate)
    }

    public function get bufferLength() : Duration
    {
      return isNaN(stream.bufferLength) ? null
        : Duration.seconds(stream.bufferLength)
    }

    public function get bufferTime() : Duration
    {
      return isNaN(stream.bufferTime) ? null
        : Duration.seconds(stream.bufferTime)
    }

    public function set bufferTime(value : Duration) : void
    {
      if (!Duration.equals(value, bufferTime))
        $bufferTime = value
    }

    private var setBufferTimeToken : Object = null

    private function set $bufferTime(value : Duration) : void
    {
      debug("Setting buffer size to " + value + ".")

      stream.bufferTime = value.seconds

      confirmBufferSizeChanged(value)
    }

    private function confirmBufferSizeChanged(value : Duration) : void
    {
      const token : Object = new Object

      setBufferTimeToken = token

      later(function () : void {
        if (setBufferTimeToken == token)
          if (!Duration.equals(bufferTime, value))
            debug("Buffer size automatically reverted to " + bufferTime + ".")
      })
    }

    public function get volume() : Number
    {
      try
        { return stream.soundTransform.volume }
      catch (error : Error)
        { return NaN }

      throw new Error
    }

    public function set volume(value : Number) : void
    {
      try
        { stream.soundTransform = getSoundTransform(value) }
      catch (error : Error)
        {}
    }

    private function getSoundTransform(volume : Number) : SoundTransform
    {
      const result : SoundTransform = new SoundTransform

      result.volume = clamp(volume, 0, 1)

      return result
    }

    public function close() : void
    { stream.close() }

    private static const PLAYLIST_RESET : String
      = "NetStream.Play.Reset"
    private static const STREAMING_STARTED : String
      = "NetStream.Play.Start"
    private static const STREAMING_STOPPED : String
      = "NetStream.Play.Stop"
    private static const BUFFER_FILLED : String
      = "NetStream.Buffer.Full"
    private static const BUFFER_EMPTIED : String
      = "NetStream.Buffer.Empty"
    private static const BUFFER_FLUSH : String
      = "NetStream.Buffer.Flush"
    private static const PAUSED : String
      = "NetStream.Pause.Notify"
    private static const RESUMED : String
      = "NetStream.Unpause.Notify"
    private static const SEEKED : String
      = "NetStream.Seek.Notify"
    private static const SWITCHED_STREAM  : String
      = "NetStream.Play.Transition"
  }
}
