package goplayer
{
  import flash.display.Sprite

  public class BufferIndicator extends Component
  {
    private const canvas : Sprite = new Sprite

    private var _ratio : Number = 0

    public function BufferIndicator()
    {
      mouseEnabled = false
      mouseChildren = false

      addChild(new Background(0x000000, 0.5))
      addChild(canvas)
    }

    public function get ratio() : Number
    { return _ratio }

    public function set ratio(value : Number) : void
    { _ratio = value, update() }

    override public function update() : void
    {
      super.update()

      canvas.graphics.clear()      
      canvas.graphics.beginFill(0xffffff, .3)
      canvas.graphics.lineStyle(size / 8, 0xffffff, .1)

      moveTo(ratio == 0 ? getPosition(0) : dimensions.center)
      plotArc(1 - ratio)

      canvas.graphics.endFill()
    }

    private function plotArc(length : Number) : void
    {
      const steps : uint = 100 * length + 1

      for (var i : uint = 0; i <= steps; ++i)
        lineTo(getPosition(i / steps * length))
    }

    private function moveTo(position : Position) : void
    { canvas.graphics.moveTo(position.x, position.y) }

    private function lineTo(position : Position) : void
    { canvas.graphics.lineTo(position.x, position.y) }

    private function getPosition(phase : Number) : Position
    {
      return Angle.ratio(phase - .25).position.horizontallyFlipped
        .scaledBy(size / 2).plus(dimensions.halved)
    }

    private function get size() : Number
    { return dimensions.innerSquare.width / 3 }
  }
}
