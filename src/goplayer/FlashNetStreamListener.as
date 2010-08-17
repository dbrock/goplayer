package goplayer
{
  public interface FlashNetStreamListener
  {
    function handleNetStreamStatus(code : String) : void
    function handleNetStreamAsyncError(message : String) : void
    function handleNetStreamMetadata(data : Object) : void
  }
}
