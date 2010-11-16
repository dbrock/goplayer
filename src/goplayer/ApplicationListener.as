package goplayer
{
  public interface ApplicationListener
  {
    function handleCurrentTimeChanged() : void
    function handlePlaybackEnded() : void
  }
}
