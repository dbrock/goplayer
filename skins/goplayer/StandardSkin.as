package goplayer
{
  import flash.display.DisplayObject
  import flash.display.Sprite
  import flash.text.TextField

	public class StandardSkin extends AbstractStandardSkin
  {
    override public function update() : void
    {
      super.update()

      controlBar.y = dimensions.height - leftSide.height
      Packer.packLeft(leftSide, [seekBar, seekBarWidth], rightSide)
    }

    override protected function get seekBarWidth() : Number
    { return dimensions.width - leftSide.width - rightSide.width }

    private function get leftSide() : Sprite
    { return lookup("controlBar.leftSide") }
    private function get rightSide() : Sprite
    { return lookup("controlBar.rightSide") }

    override protected function get leftTimeField() : TextField
    { return lookup("controlBar.leftSide.timeField") }
    override protected function get playButton() : DisplayObject
    { return lookup("controlBar.leftSide.playButton") }
    override protected function get pauseButton() : DisplayObject
    { return lookup("controlBar.leftSide.pauseButton") }

    override protected function get seekBar() : Sprite
    { return lookup("controlBar.seekBar") }
    override protected function get seekBarBackground() : DisplayObject
    { return lookup("controlBar.seekBar.background") }
    override protected function get seekBarBuffer() : DisplayObject
    { return lookup("controlBar.seekBar.buffer") }
    override protected function get seekBarPlayhead() : DisplayObject
    { return lookup("controlBar.seekBar.playhead") }
    override protected function get seekBarTooltip() : DisplayObject
    { return lookup("controlBar.seekBar.tooltip") }
    override protected function get seekBarTooltipField() : TextField
    { return lookup("controlBar.seekBar.tooltip.field") }

    override protected function get rightTimeField() : TextField
    { return lookup("controlBar.rightSide.timeField") }
    override protected function get muteButton() : DisplayObject
    { return lookup("controlBar.rightSide.muteButton") }
    override protected function get unmuteButton() : DisplayObject
    { return lookup("controlBar.rightSide.unmuteButton") }
    override protected function get enableFullscreenButton() : DisplayObject
    { return lookup("controlBar.rightSide.enableFullscreenButton") }
	}
}
