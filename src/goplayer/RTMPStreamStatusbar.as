package goplayer
{
  import flash.display.Sprite

  public class RTMPStreamStatusbar extends Sprite
  {
    private const margins : Dimensions = new Dimensions(10, 5)
    private const label : Label = new Label

    private var player : RTMPStreamPlayer

    public function RTMPStreamStatusbar(player : RTMPStreamPlayer)
    {
      this.player = player

      addChild(label)

      label.x = margins.width
      label.y = margins.height
    }

    public function update() : void
    {
      label.text
        = "Playhead: "
        + formatDuration(player.playheadPosition) + "/"
        + formatDuration(player.streamLength)
        + "  "
        + "Buffer: "
        + formatDuration(player.bufferLength) + "/"
        + formatDuration(player.bufferTime)
        + "  "
        + "Volume: " + Math.round(player.volume * 100) + "%"

      redraw()
    }

    private function formatDuration(value : Number) : String
    { return value.toFixed(1) + "s" }

    private function redraw() : void
    {
      graphics.clear()
      graphics.beginFill(0x000000, 0.3)
      drawRectangle(Position.ZERO, label.dimensions.plus(margins.doubled))
      graphics.endFill()
    }

    private function drawRectangle
      (position : Position, dimensions : Dimensions) : void
    {
      graphics.drawRect
        (position.x, position.y, dimensions.width, dimensions.height)
    }
  }
}
