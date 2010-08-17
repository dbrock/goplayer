package goplayer
{
  public interface FlashNetStreamListener
  {
    function handleStreamingStopped() : void
    function handleBufferEmptied() : void
    function handleNetStreamMetadata(data : Object) : void
  }
}
