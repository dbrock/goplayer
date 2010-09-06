package goplayer
{
  import flash.utils.getTimer

  public class Stopwatch
  {
    private var startTime : uint
    private var _started : Boolean = false

    public function start() : void
    { startTime = getTimer(), _started = true }

    public function get started() : Boolean
    { return _started }

    public function getElapsedTime() : Duration
    {
      if (started)
        return Duration.milliseconds(getTimer() - startTime)
      else
        throw new Error
    }

    public function within(limit : Duration) : Boolean
    { return started && !getElapsedTime().isGreaterThan(limit) }
  }
}
