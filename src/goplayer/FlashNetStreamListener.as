package goplayer
{
  public interface FlashNetStreamListener
  {
    function handleNetStreamMetadata(data : Object) : void
    function handleStreamingStarted() : void
    function handleBufferFilled() : void
    function handleBufferEmptied() : void
    function handleStreamingStopped() : void
    function handleCurrentTimeChanged() : void
  }
}
