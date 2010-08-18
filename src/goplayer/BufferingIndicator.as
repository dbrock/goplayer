package goplayer
{
  import flash.display.Sprite


  public class BufferingIndicator extends Sprite
  {
    public var size : Number = 0
    public var ratio : Number = 0

    public function update() : void
    {
      graphics.clear()
      
      graphics.beginFill(0xffffff, .3)
      graphics.lineStyle(size / 8, 0xffffff, .1)

      moveTo(ratio == 0 ? getPosition(0) : Position.ZERO)

      plotArc(1 - ratio)
      
      graphics.endFill()
    }

    private function plotArc(length : Number) : void
    {
      const steps : uint = 100 * length

      for (var i : uint = 0; i <= steps; ++i)
        lineTo(getPosition(i / steps * length))
    }

    private function moveTo(position : Position) : void
    { graphics.moveTo(position.x, position.y) }

    private function lineTo(position : Position) : void
    { graphics.lineTo(position.x, position.y) }

    private function getPosition(phase : Number) : Position
    {
      const angle : Number = (phase - .25) * Math.PI * 2

      const x : Number = -Math.cos(angle) * size / 2
      const y : Number = +Math.sin(angle) * size / 2

      return new Position(x, y)
    }
  }
}
