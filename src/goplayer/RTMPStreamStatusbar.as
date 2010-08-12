package goplayer
{
  import flash.display.Sprite

  public class RTMPStreamStatusbar extends Sprite
  {
    private const margins : Dimensions = new Dimensions(10, 5)
    private const label : Label = new Label

    private var _bufferLength : Number = NaN
    private var _bufferTime : Number = NaN
    private var _playheadPosition : Number = NaN
    private var _streamLength : Number = NaN

    public function RTMPStreamStatusbar()
    {
      addChild(label)

      label.x = margins.width
      label.y = margins.height
    }

    public function set bufferLength(value : Number) : void
    { _bufferLength = value, update() }

    public function set bufferTime(value : Number) : void
    { _bufferTime = value, update() }

    public function set playheadPosition(value : Number) : void
    { _playheadPosition = value, update() }

    public function set streamLength(value : Number) : void
    { _streamLength = value, update() }

    private function update() : void
    {
      label.text = playheadString + "  " + bufferString
      redraw()
    }

    private function get playheadString() : String
    { return "Playhead: " + playheadPositionString + "/" + streamLengthString }

    private function get playheadPositionString() : String
    { return round(_playheadPosition) + "s" }

    private function get streamLengthString() : String
    { return round(_streamLength) + "s" }

    private function get bufferString() : String
    { return "Buffer: " + bufferLengthString + "/" + bufferTimeString }

    private function get bufferLengthString() : String
    { return round(_bufferLength) + "s" }

    private function get bufferTimeString() : String
    { return round(_bufferTime) + "s" }

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
