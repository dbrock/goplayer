package goplayer
{
  import com.adobe.fms.DynamicStream
  import com.adobe.fms.DynamicStreamItem

  import flash.events.AsyncErrorEvent
  import flash.events.NetStatusEvent
  import flash.media.SoundTransform
  import flash.media.Video
  import flash.net.NetConnection
  import flash.net.NetStream

  public class StandardFlashNetStream implements FlashNetStream
  {
    private var stream : DynamicStream

    private var _listener : FlashNetStreamListener

    public function StandardFlashNetStream
      (connection : NetConnection, video : Video)
    {
      // stream = new NetStream(connection)
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

    public function play(stream : RTMPStream, streams : Array) : void
    { this.stream.startPlay(getDynamicStreamItem(stream, streams)) }

    private function getDynamicStreamItem
      (stream : RTMPStream, streams : Array) : DynamicStreamItem
    {
      const result : DynamicStreamItem = new DynamicStreamItem

      for each (var stream : RTMPStream in streams)
        result.addStream(stream.name, stream.bitrate.kbps)

      result.startRate = stream.bitrate.kbps

      return result
    }

    public function set paused(value : Boolean) : void
    {
      if (value)
        stream.pause()
      else
        stream.resume()
    }

    public function get playheadPosition() : Duration
    { return Duration.seconds(stream.time) }

    public function set playheadPosition(position : Duration) : void
    { stream.seek(position.seconds) }

    public function get bandwidth() : Bitrate
    { return Bitrate.kbps(stream.maxBandwidth) }

    public function get bitrate() : Bitrate
    { return Bitrate.kbps(stream.currentStreamBitRate) }

    public function get bufferLength() : Duration
    { return Duration.seconds(stream.bufferLength) }

    public function get bufferTime() : Duration
    { return Duration.seconds(stream.bufferTime) }

    public function set bufferTime(value : Duration) : void
    {
      debug("Setting buffer size to " + value + ".")
      stream.bufferTime = value.seconds
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
