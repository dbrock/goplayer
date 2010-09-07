package goplayer
{
  public class Background extends EphemeralComponent
  {
    public function Background(color : uint, alpha : Number)
    {
      this.color = color
      this.alpha = alpha
    }

    override public function update() : void
    { width = dimensions.width, height = dimensions.height }

    public function set color(value : uint) : void
    {
      graphics.clear()
      graphics.beginFill(value)
      graphics.drawRect(0, 0, 1, 1)
      graphics.endFill()
    }
  }
}
