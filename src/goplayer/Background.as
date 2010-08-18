package goplayer
{
  import flash.display.Sprite

  public class Background extends Sprite
  {
    public function Background(color : uint, alpha : Number)
    { this.color = color, this.alpha = alpha }

    public function set dimensions(value : Dimensions) : void
    { width = value.width, height = value.height }

    public function set color(value : uint) : void
    {
      graphics.clear()
      graphics.beginFill(value)
      graphics.drawRect(0, 0, 1, 1)
      graphics.endFill()
    }
  }
}
