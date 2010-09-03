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

      setPosition(largePlayButton, dimensions.center)

      controlBar.x = 10
      controlBar.y = dimensions.height - 10

      Packer.packLeft(leftSide, [seekBar, seekBarWidth], rightSide)
    }

    override protected function get seekBarWidth() : Number
    { return dimensions.width - 20 - leftSide.width - rightSide.width }

    private function get leftSide() : Sprite
    { return lookup("controlBar.leftSide") }
    private function get rightSide() : Sprite
    { return lookup("controlBar.rightSide") }

    override protected function get controlBar() : Sprite
    { return lookup("controlBar") }

    override protected function get largePlayButton() : DisplayObject
    { return lookup("largePlayButton") }

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

    override protected function get volumeSlider() : Sprite
    { return lookup("controlBar.rightSide.volumeControl") }
    override protected function get volumeSliderThumb() : DisplayObject
    { return lookup("controlBar.rightSide.volumeControl.thumb") }
    override protected function get volumeSliderThumbGuide() : DisplayObject
    { return lookup("controlBar.rightSide.volumeControl.thumbGuide") }
    override protected function get volumeSliderFill() : DisplayObject
    { return lookup("controlBar.rightSide.volumeControl.fill") }

    override protected function lookup(name : String) : *
    { return super.lookup("skinContent." + name) }
	}
}
