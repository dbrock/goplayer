package goplayer
{
  import flash.display.Sprite
  import flash.events.Event
  import flash.utils.getTimer

  public class BufferingIndicator extends Component
  {
    private static const dotCount : uint = 10
    private static const period : Duration = Duration.seconds(1)

    private const canvas : Sprite = new Sprite

    private var elapsedTime : Duration = Duration.milliseconds(0)
    private var lastState : uint = 0

    public function BufferingIndicator()
    {
      mouseEnabled = false
      mouseChildren = false

      addChild(new Background(0x000000, 0.5))
      addChild(canvas)

      addEventListener(Event.ENTER_FRAME, handleEnterFrame)
    }

    private function handleEnterFrame(event : Event) : void
    {
      if (dimensions != null)
        $handleEnterFrame()
    }

    private function $handleEnterFrame() : void
    {
      elapsedTime = Duration.milliseconds(getTimer())
      
      if (currentState != lastState)
        update(), lastState = currentState
    }

    private function get currentState() : uint
    { return Math.floor(elapsedTime.dividedBy(stateLength)) % dotCount }

    private function get stateLength() : Duration
    { return Duration.seconds(period.seconds / dotCount) }

    override public function update() : void
    {
      super.update()

      canvas.graphics.clear()

      for (var i : uint = 0; i < dotCount; ++i)
        drawDot(i)
    }

    private function drawDot(index : uint) : void
    {
      const position : Position = getDotPosition(index)

      canvas.graphics.beginFill(getDotColor(index), getDotAlpha(index))
      canvas.graphics.drawCircle(position.x, position.y, getDotRadius(index))
      canvas.graphics.endFill()
    }

    private function getDotPosition(index : uint) : Position
    {
      return Angle.ratio(-(index / dotCount)).position
        .scaledBy(radius).plus(dimensions.halved)
    }

    private function get radius() : Number
    { return dimensions.innerSquare.width / 16 }

    private function getDotColor(index : uint) : uint
    { return 0xffffff }

    private function getDotAlpha(index : uint) : Number
    { return (dotCount - modulated(index)) / dotCount }

    private function getDotRadius(index : uint) : Number
    { return radius / 4 }

    private function modulated(index : uint) : uint
    { return (index + currentState) % dotCount }
  }
}
