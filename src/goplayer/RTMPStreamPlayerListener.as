package goplayer
{
  public interface RTMPStreamPlayerListener
  {
    function handleRTMPStreamCreated() : void
    function handleRTMPStreamUpdated() : void
    function handleRTMPStreamFinishedPlaying() : void
  }
}
