package goplayer
{
  public interface PlayerBufferingListener
  {
    function handleBufferingStarted() : void
    function handleBufferingFinished() : void
  }
}
