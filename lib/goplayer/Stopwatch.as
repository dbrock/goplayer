package goplayer
{
  import flash.utils.getTimer

  public class Stopwatch
  {
    private var _running : Boolean = false
    private var startTime : uint

    public function start() : void
    { _running = true, startTime = getTimer() }

    public function reset() : void
    { _running = false }

    public function get running() : Boolean
    { return _running }

    public function getElapsedTime() : Duration
    {
      if (running)
        return Duration.milliseconds(getTimer() - startTime)
      else
        throw new Error
    }

    public function within(limit : Duration) : Boolean
    { return running && !getElapsedTime().isGreaterThan(limit) }
  }
}
