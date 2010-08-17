package goplayer
{
  public interface FlashNetConnectionListener
  {
    function handleNetConnectionEstablished() : void
    function handleNetConnectionFailed() : void
    function handleNetConnectionClosed() : void
  }
}
