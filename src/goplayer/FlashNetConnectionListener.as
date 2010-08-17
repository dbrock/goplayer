package goplayer
{
  public interface FlashNetConnectionListener
  {
    function handleNetConnectionStatus(code : String) : void
    function handleNetConnectionAsyncError(message : String) : void
  }
}
