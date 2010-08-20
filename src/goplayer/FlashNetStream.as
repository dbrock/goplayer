package goplayer
{
  import flash.media.Video

  public interface FlashNetStream
  {
    function set listener(value : FlashNetStreamListener) : void

    function playRTMP(stream : RTMPStream, streams : Array) : void
    function playHTTP(url : URL) : void

    function set paused(value : Boolean) : void

    function get playheadPosition() : Duration
    function set playheadPosition(value : Duration) : void

    function get bitrate() : Bitrate
    function get bandwidth() : Bitrate

    function get bufferLength() : Duration

    function get bufferTime() : Duration
    function set bufferTime(value : Duration) : void

    function get volume() : Number
    function set volume(value : Number) : void
  }
}
