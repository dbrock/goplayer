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

      titleBar.x = 0
      titleBar.y = 0

      Packer.packLeft
        (titleBarLeft,
         [titleBarMiddle, titleBarMiddleWidth],
         titleBarRight)

      titleBarMiddleBackground.width = titleBarMiddleWidth
      titleField.width = titleBarMiddleWidth

      controlBar.x = 0
      controlBar.y = dimensions.height

      Packer.packLeft
        (controlBarLeft,
         [seekBar, seekBarWidth],
         controlBarRight)
    }

    private function get titleBarMiddleWidth() : Number
    { return dimensions.width - titleBarLeft.width - titleBarRight.width }

    override protected function get seekBarWidth() : Number
    { return dimensions.width - controlBarLeft.width - controlBarRight.width }

    override protected function get titleBar() : Sprite
    { return lookup("chrome.titleBar") }
    private function get titleBarLeft() : Sprite
    { return lookup("chrome.titleBar.left") }
    private function get titleBarMiddle() : Sprite
    { return lookup("chrome.titleBar.middle") }
    private function get titleBarMiddleBackground() : Sprite
    { return lookup("chrome.titleBar.middle.background") }
    private function get titleBarRight() : Sprite
    { return lookup("chrome.titleBar.right") }

    private function get controlBarLeft() : Sprite
    { return lookup("chrome.controlBar.left") }
    private function get controlBarRight() : Sprite
    { return lookup("chrome.controlBar.right") }

    override protected function get largePlayButton() : DisplayObject
    { return lookup("largePlayButton") }

    override protected function get chrome() : Sprite
    { return lookup("chrome") }

    override protected function get titleField() : TextField
    { return lookup("chrome.titleBar.middle.titleField") }

    override protected function get controlBar() : Sprite
    { return lookup("chrome.controlBar") }

    override protected function get leftTimeField() : TextField
    { return lookup("chrome.controlBar.left.timeField") }
    override protected function get playButton() : DisplayObject
    { return lookup("chrome.controlBar.left.playButton") }
    override protected function get pauseButton() : DisplayObject
    { return lookup("chrome.controlBar.left.pauseButton") }

    override protected function get seekBar() : Sprite
    { return lookup("chrome.controlBar.seekBar") }
    override protected function get seekBarBackground() : DisplayObject
    { return lookup("chrome.controlBar.seekBar.background") }
    override protected function get seekBarBuffer() : DisplayObject
    { return lookup("chrome.controlBar.seekBar.buffer") }
    override protected function get seekBarPlayhead() : DisplayObject
    { return lookup("chrome.controlBar.seekBar.playhead") }
    override protected function get seekBarTooltip() : DisplayObject
    { return lookup("chrome.controlBar.seekBar.tooltip") }
    override protected function get seekBarTooltipField() : TextField
    { return lookup("chrome.controlBar.seekBar.tooltip.field") }

    override protected function get rightTimeField() : TextField
    { return lookup("chrome.controlBar.right.timeField") }
    override protected function get muteButton() : DisplayObject
    { return lookup("chrome.controlBar.right.muteButton") }
    override protected function get unmuteButton() : DisplayObject
    { return lookup("chrome.controlBar.right.unmuteButton") }
    override protected function get enableFullscreenButton() : DisplayObject
    { return lookup("chrome.controlBar.right.enableFullscreenButton") }

    override protected function get volumeSlider() : Sprite
    { return lookup("chrome.controlBar.right.volumeSlider") }
    override protected function get volumeSliderThumb() : DisplayObject
    { return lookup("chrome.controlBar.right.volumeSlider.thumb") }
    override protected function get volumeSliderThumbGuide() : DisplayObject
    { return lookup("chrome.controlBar.right.volumeSlider.thumbGuide") }
    override protected function get volumeSliderFill() : DisplayObject
    { return lookup("chrome.controlBar.right.volumeSlider.fill") }

    override protected function lookup(name : String) : *
    { return super.lookup("skinContent." + name) }
	}
}
