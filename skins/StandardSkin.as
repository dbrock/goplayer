package
{
	public class StandardSkin extends AbstractSkin
  {
    override protected function update() : void
    {
      controlBar.x = 0
      controlBar.y = height - controlBar.height

      controlBar.leftSide.x = 0
      controlBar.seekBar.x = controlBar.leftSide.width
      controlBar.rightSide.x = width - controlBar.rightSide.width

      controlBar.seekBar.background.width
        = controlBar.rightSide.x - controlBar.seekBar.x
      controlBar.seekBar.buffer.width
        = controlBar.seekBar.background.width * bufferRatio
      controlBar.seekBar.playhead.width
        = controlBar.seekBar.background.width * playheadRatio
    }

    override public function get playButtonName() : String
    { return "controlBar.leftSide.playButton" }

    override public function get pauseButtonName() : String
    { return "controlBar.leftSide.pauseButton" }

    override public function get leftTimeFieldName() : String
    { return "controlBar.leftSide.timeField" }

    override public function get rightTimeFieldName() : String
    { return "controlBar.rightSide.timeField" }

    override public function get muteButtonName() : String
    { return "controlBar.rightSide.muteButton" }

    override public function get unmuteButtonName() : String
    { return "controlBar.rightSide.unmuteButton" }

    override public function get enableFullscreenButtonName() : String
    { return "controlBar.rightSide.enableFullscreenButton" }
	}
}
