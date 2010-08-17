package goplayer
{
  import flash.events.AsyncErrorEvent
  import flash.events.NetStatusEvent
  import flash.media.SoundTransform
  import flash.media.Video
  import flash.net.NetConnection
  import flash.net.NetStream

  public class StandardFlashNetStream implements FlashNetStream
  {
    private var stream : NetStream

    private var _listener : FlashNetStreamListener

    public function StandardFlashNetStream
      (connection : NetConnection, video : Video)
    {
      stream = new NetStream(connection)

      video.attachNetStream(stream)

      stream.addEventListener
        (NetStatusEvent.NET_STATUS, handleNetStreamStatus)
      stream.addEventListener
        (AsyncErrorEvent.ASYNC_ERROR, handleAsyncError)
      stream.client = { onMetaData: handleNetStreamMetadata }
    }

    private function handleNetStreamStatus
      (event : NetStatusEvent) : void
    { _listener.handleNetStreamStatus(event.info.code) }

    private function handleAsyncError(event : AsyncErrorEvent) : void
    { _listener.handleNetStreamAsyncError(event.error.message) }

    private function handleNetStreamMetadata(data : Object) : void
    { _listener.handleNetStreamMetadata(data) }

    // -----------------------------------------------------

    public function set listener(value : FlashNetStreamListener) : void
    { _listener = value }

    public function play(name : String) : void
    { stream.play(name) }

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

    public function get bufferLength() : Duration
    { return Duration.seconds(stream.bufferLength) }

    public function get bufferTime() : Duration
    { return Duration.seconds(stream.bufferTime) }

    public function set bufferTime(value : Duration) : void
    { stream.bufferTime = value.seconds }

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
  }
}
