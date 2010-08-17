package goplayer
{
  public interface FlashNetConnectionListener
  {
    function handleConnectionEstablished() : void
    function handleConnectionFailed() : void
    function handleConnectionClosed() : void
  }
}
