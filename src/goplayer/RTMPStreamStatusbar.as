package goplayer
{
  import flash.display.Sprite

  public class RTMPStreamStatusbar extends Sprite
  {
    private const margins : Dimensions = new Dimensions(10, 5)
    private const label : Label = new Label

    private var engine : RTMPStreamPlayerEngine

    public function RTMPStreamStatusbar
      (engine : RTMPStreamPlayerEngine)
    {
      this.engine = engine

      addChild(label)

      label.x = margins.width
      label.y = margins.height
    }

    public function update() : void
    {
      label.text = playheadString + "  " + bufferString + "  " + volumeString
      redraw()
    }

    private function get playheadString() : String
    { return "Playhead: " + playheadPositionString + "/" + streamLengthString }

    private function get playheadPositionString() : String
    { return round(engine.playheadPosition) + "s" }

    private function get streamLengthString() : String
    { return round(engine.streamLength) + "s" }

    private function get bufferString() : String
    { return "Buffer: " + bufferLengthString + "/" + bufferTimeString }

    private function get bufferLengthString() : String
    { return round(engine.bufferLength) + "s" }

    private function get bufferTimeString() : String
    { return round(engine.bufferTime) + "s" }

    private function get volumeString() : String
    { return "Volume: " + Math.round(engine.volume * 100) + "%" }

    private function round(value : Number) : String
    { return value.toFixed(1) }

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
