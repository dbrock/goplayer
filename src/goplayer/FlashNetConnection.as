package goplayer
{
  public interface FlashNetConnection
  {
    function set listener(value : FlashNetConnectionListener) : void
    function connect(url : URL) : void
    function dontConnect() : void
    function determineBandwidth() : void
    function getNetStream() : FlashNetStream
  }
}
