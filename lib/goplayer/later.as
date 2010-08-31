package goplayer
{
  import flash.events.TimerEvent
  import flash.utils.Timer

  public function later(callback : Function) : void
  {
    const timer : Timer = new Timer(0, 1)

    timer.addEventListener(TimerEvent.TIMER,
      function (event : TimerEvent) : void
      { callback() })

    timer.start()
  }
}
