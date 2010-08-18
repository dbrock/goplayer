package goplayer
{
  import flash.media.Video

  public interface FlashNetStream
  {
    function set listener(value : FlashNetStreamListener) : void

    function play(streams : Array) : void

    function set paused(value : Boolean) : void

    function get playheadPosition() : Duration
    function set playheadPosition(value : Duration) : void

    function get bufferLength() : Duration

    function get bufferTime() : Duration
    function set bufferTime(value : Duration) : void

    function get volume() : Number
    function set volume(value : Number) : void
  }
}
