package goplayer
{
  import flash.display.DisplayObject
  import flash.display.InteractiveObject
  import flash.display.Sprite
  import flash.text.TextField

	public class StandardSkin extends AbstractStandardSkin
  {
    private const _bufferingIndicator : BufferingIndicator
      = new BufferingIndicator

    private var _seekBarWidth : Number

    override protected function initialize() : void
    {
      super.initialize()

      addChildAt(bufferingIndicator, 0)
    }
    
    override public function update() : void
    {
      super.update()

      setPosition(largePlayButton, dimensions.center)
      setDimensions(largePlayButton, dimensions.halved.innerSquare)

      setPosition(popupBackground, new Position(0, 0))
      setDimensions(popupBackground, dimensions)

      setPosition(sharePopup, dimensions.center)
      setPosition(embedPopup, dimensions.center)

      if (chrome.visible)
        layoutChrome()
    }

    private function layoutChrome() : void
    {
      upperPanel.visible = showUpperPanel
      controlBar.visible = showControlBar

      if (upperPanel.visible)
        layoutUpperPanel()

      if (controlBar.visible)
        layoutControlBar()
    }

    private function layoutUpperPanel() : void
    {
      upperPanel.x = 0
      upperPanel.y = 0

      packLeft
        (upperPanelLeft,
         [upperPanelMiddle, setUpperPanelMiddleWidth],
         upperPanelRight,
         showShareButton ? shareButtonPart : null,
         showEmbedButton ? embedButtonPart : null)

      titleField.visible = showTitle
      shareButtonPart.visible = showShareButton
      embedButtonPart.visible = showEmbedButton
    }

    private function layoutControlBar() : void
    {
      controlBar.x = 0
      controlBar.y = dimensions.height

      packLeft
        (showPlayPauseButton ? playPausePart : null,
         beforeLeftTimePart,
         showElapsedTime ? leftTimeBackgroundPart : null,
         showSeekBar ? afterLeftTimePart : null,
         [seekBarBackground, setSeekBarWidth],
         showSeekBar ? beforeRightTimePart : null,
         showTotalTime ? rightTimeBackgroundPart : null,
         afterRightTimePart,
         showVolumeControl ? volumePart : null,
         showFullscreenButton ? fullscreenPart : null)

      leftTimeFieldPart.x = beforeLeftTimePart.x
      rightTimeFieldPart.x = beforeRightTimePart.x
      seekBar.x = seekBarBackground.x

      playPausePart.visible = showPlayPauseButton
      leftTimeBackgroundPart.visible = showElapsedTime
      leftTimeFieldPart.visible = showElapsedTime
      afterLeftTimePart.visible = showSeekBar
      seekBar.visible = showSeekBar
      beforeRightTimePart.visible = showSeekBar
      rightTimeBackgroundPart.visible = showTotalTime
      rightTimeFieldPart.visible = showTotalTime
      volumePart.visible = showVolumeControl
      fullscreenPart.visible = showFullscreenButton
    }

    private function packLeft(... items : Array) : void
    { Packer.$packLeft(dimensions.width, items) }

    private function setUpperPanelMiddleWidth(value : Number) : void
    {
      upperPanelMiddleBackground.width = value
      titleField.width = value
    }

    private function setSeekBarWidth(value : Number) : void
    { _seekBarWidth = value }

    override protected function get seekBarWidth() : Number
    { return _seekBarWidth }

    // -----------------------------------------------------

    private function get showUpperPanel() : Boolean
    {
      return false
        || showTitle
        || showShareButton
        || showEmbedButton
    }

    private function get showControlBar() : Boolean
    {
      return false
        || showPlayPauseButton
        || showElapsedTime
        || showSeekBar
        || showTotalTime
        || showVolumeControl
        || showFullscreenButton
    }

    // -----------------------------------------------------

    override protected function get largePlayButton() : InteractiveObject
    { return lookup("largePlayButton") }
    override protected function get bufferingIndicator() : InteractiveObject
    { return _bufferingIndicator }

    override protected function get popupBackground() : InteractiveObject
    { return lookup("popupBackground") }
    override protected function get sharePopup() : InteractiveObject
    { return lookup("sharePopup") }
    override protected function get embedPopup() : InteractiveObject
    { return lookup("embedPopup") }

    override protected function get shareLinkField() : TextField
    { return lookup("sharePopup.linkField") }
    override protected function get copyShareLinkButton() : DisplayObject
    { return lookup("sharePopup.copyLinkButton") }
    override protected function get shareLinkCopiedMessage() : DisplayObject
    { return lookup("sharePopup.linkCopiedMessage") }
    override protected function get twitterButton() : DisplayObject
    { return lookup("sharePopup.twitterButton") }
    override protected function get facebookButton() : DisplayObject
    { return lookup("sharePopup.facebookButton") }

    override protected function get embedCodeField() : TextField
    { return lookup("embedPopup.codeField") }
    override protected function get copyEmbedCodeButton() : DisplayObject
    { return lookup("embedPopup.copyCodeButton") }
    override protected function get embedCodeCopiedMessage() : DisplayObject
    { return lookup("embedPopup.codeCopiedMessage") }

    override protected function get chrome() : Sprite
    { return lookup("chrome") }

    private function get upperPanel() : Sprite
    { return lookup("chrome.upperPanel") }
    private function get controlBar() : Sprite
    { return lookup("chrome.controlBar") }

    // -----------------------------------------------------

    private function get upperPanelLeft() : Sprite
    { return lookup("chrome.upperPanel.left") }

    private function get upperPanelMiddle() : Sprite
    { return lookup("chrome.upperPanel.middle") }
    private function get upperPanelMiddleBackground() : Sprite
    { return lookup("chrome.upperPanel.middle.background") }
    override protected function get titleField() : TextField
    { return lookup("chrome.upperPanel.middle.titleField") }

    private function get shareButtonPart() : DisplayObject
    { return lookup("chrome.upperPanel.share") }
    override protected function get shareButton() : DisplayObject
    { return lookup("chrome.upperPanel.share.button") }

    private function get embedButtonPart() : DisplayObject
    { return lookup("chrome.upperPanel.embed") }
    override protected function get embedButton() : DisplayObject
    { return lookup("chrome.upperPanel.embed.button") }

    private function get upperPanelRight() : Sprite
    { return lookup("chrome.upperPanel.right") }

    // -----------------------------------------------------

    private function get playPausePart() : DisplayObject
    { return lookup("chrome.controlBar.playPause") }
    override protected function get playButton() : DisplayObject
    { return lookup("chrome.controlBar.playPause.playButton") }
    override protected function get pauseButton() : DisplayObject
    { return lookup("chrome.controlBar.playPause.pauseButton") }

    // -----------------------------------------------------

    private function get beforeLeftTimePart() : DisplayObject
    { return lookup("chrome.controlBar.beforeLeftTime") }

    private function get leftTimeBackgroundPart() : DisplayObject
    { return lookup("chrome.controlBar.leftTimeBackground") }
    private function get leftTimeFieldPart() : DisplayObject
    { return lookup("chrome.controlBar.leftTime") }
    override protected function get leftTimeField() : TextField
    { return lookup("chrome.controlBar.leftTime.field") }

    private function get afterLeftTimePart() : DisplayObject
    { return lookup("chrome.controlBar.afterLeftTime") }

    // -----------------------------------------------------

    override protected function get seekBarBackground() : DisplayObject
    { return lookup("chrome.controlBar.seekBarBackground") }

    override protected function get seekBar() : Sprite
    { return lookup("chrome.controlBar.seekBar") }
    override protected function get seekBarGroove() : DisplayObject
    { return lookup("chrome.controlBar.seekBar.groove") }
    override protected function get seekBarBuffer() : DisplayObject
    { return lookup("chrome.controlBar.seekBar.buffer") }
    override protected function get seekBarPlayhead() : DisplayObject
    { return lookup("chrome.controlBar.seekBar.playhead") }
    override protected function get seekBarTooltip() : DisplayObject
    { return lookup("chrome.controlBar.seekBar.tooltip") }
    override protected function get seekBarTooltipField() : TextField
    { return lookup("chrome.controlBar.seekBar.tooltip.field") }

    // -----------------------------------------------------

    private function get beforeRightTimePart() : DisplayObject
    { return lookup("chrome.controlBar.beforeRightTime") }

    private function get rightTimeBackgroundPart() : DisplayObject
    { return lookup("chrome.controlBar.rightTimeBackground") }
    private function get rightTimeFieldPart() : DisplayObject
    { return lookup("chrome.controlBar.rightTime") }
    override protected function get rightTimeField() : TextField
    { return lookup("chrome.controlBar.rightTime.field") }

    private function get afterRightTimePart() : DisplayObject
    { return lookup("chrome.controlBar.afterRightTime") }

    // -----------------------------------------------------

    private function get volumePart() : DisplayObject
    { return lookup("chrome.controlBar.volume") }
    override protected function get muteButton() : DisplayObject
    { return lookup("chrome.controlBar.volume.muteButton") }
    override protected function get unmuteButton() : DisplayObject
    { return lookup("chrome.controlBar.volume.unmuteButton") }
    override protected function get volumeSlider() : Sprite
    { return lookup("chrome.controlBar.volume.slider") }
    override protected function get volumeSliderThumb() : DisplayObject
    { return lookup("chrome.controlBar.volume.slider.thumb") }
    override protected function get volumeSliderThumbGuide() : DisplayObject
    { return lookup("chrome.controlBar.volume.slider.thumbGuide") }
    override protected function get volumeSliderFill() : DisplayObject
    { return lookup("chrome.controlBar.volume.slider.fill") }

    private function get fullscreenPart() : DisplayObject
    { return lookup("chrome.controlBar.fullscreen") }
    override protected function get enableFullscreenButton() : DisplayObject
    { return lookup("chrome.controlBar.fullscreen.enableButton") }

    // -----------------------------------------------------

    override protected function lookup(name : String) : *
    { return super.lookup("skinContent." + name) }
	}
}
