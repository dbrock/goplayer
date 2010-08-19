package goplayer
{
  import flash.display.Sprite

  public class PlayerStatusbar extends Sprite
  {
    private const margins : Dimensions = new Dimensions(10, 5)
    private const label : Label = new Label

    private var player : Player

    public function PlayerStatusbar(player : Player)
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
        + player.playheadPosition + "/"
        + player.streamLength
        + (player.paused ? " (paused)" : "")
        + "  "
        + "Buffer: "
        + player.bufferLength + "/"
        + player.bufferTime
        + "  "
        + "Bitrate: "
        + player.currentBandwidth + "/"
        + player.currentBitrate
        + "  "
        + "Volume: " + Math.round(player.volume * 100) + "%"

      redraw()
    }

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
