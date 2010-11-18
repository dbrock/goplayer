package goplayer
{
  import flash.display.DisplayObject
  import flash.display.InteractiveObject
  import flash.display.Sprite
  import flash.events.Event
  import flash.events.MouseEvent
  import flash.geom.Point
  import flash.geom.Rectangle
  import flash.text.TextField

	public class AbstractStandardSkin extends AbstractSkin
  {
    private var chromeFader : Fader
    private var largePlayButtonFader : Fader
    private var bufferingIndicatorFader : Fader

    private var hoveringChrome : Boolean = false
    private var showRemainingTime : Boolean = false
    private var changingVolume : Boolean = false

    private var volumeSliderFillMaxHeight : Number
    private var volumeSliderFillMinY : Number

    override protected function initialize() : void
    {
      super.initialize()

      chromeFader = new Fader(chrome, Duration.seconds(.3))
      largePlayButtonFader = new Fader
        (largePlayButton, Duration.seconds(1))
      bufferingIndicatorFader = new Fader
        (bufferingIndicator, Duration.seconds(.3))

      seekBarTooltip.visible = false
      seekBar.mouseChildren = false
      seekBar.buttonMode = true

      bufferingIndicator.mouseEnabled = false

      volumeSliderFillMaxHeight = volumeSliderFill.height
      volumeSliderFillMinY = volumeSliderFill.y
      volumeSlider.mouseChildren = false
      volumeSlider.buttonMode = true

      volumeSliderThumbGuide.visible = false

      volumeSlider.visible = false

      chrome.visible = enableChrome

      addEventListeners()
    }

    override public function update() : void
    {
      super.update()

      chromeFader.targetAlpha = showChrome ? 1 : 0

      upperPanel.visible = showTitle
      titleField.text = titleText

      if (!changingVolume && !hoveringVolumeControl)
        volumeSlider.visible = false

      playButton.visible = !playing
      pauseButton.visible = playing
      muteButton.visible = !muted
      unmuteButton.visible = muted

      volumeSliderThumb.y = volumeSliderThumbY
      volumeSliderFill.height = volumeSliderFillMaxHeight * volume
      volumeSliderFill.y = volumeSliderFillMinY
        + volumeSliderFillMaxHeight * (1 - volume)

      leftTimeField.text = elapsedTimeText
      rightTimeField.text = showRemainingTime
        ? remainingTimeText : totalTimeText

      seekBarBackground.width = seekBarWidth
      seekBarGroove.width = seekBarWidth
      seekBarBuffer.width = seekBarWidth * bufferRatio
      seekBarPlayhead.width = seekBarWidth * playheadRatio

      seekBarTooltip.x = seekBar.mouseX
      seekBarTooltipField.text = seekTooltipText

      largePlayButtonFader.targetAlpha = showLargePlayButton ? 1 : 0
      largePlayButton.mouseEnabled = showLargePlayButton

      bufferingIndicatorFader.targetAlpha = bufferingUnexpectedly ? 1 : 0
    }

    private function get showLargePlayButton() : Boolean
    { return !running }

    override protected function get showChrome() : Boolean
    { return super.showChrome || hoveringChrome }

    private function get volumeSliderMouseVolume() : Number
    {
      return 1 - (volumeSlider.mouseY - volumeSliderThumbGuide.y)
        / volumeSliderThumbGuide.height
    }

    private function get volumeSliderThumbY() : Number
    {
      return volumeSliderThumbGuide.y
        + volumeSliderThumbGuide.height * (1 - volume)
    }

    private function get seekTooltipText() : String
    { return getDurationByRatio(seekBarMouseRatio).mss }

    private function get seekBarMouseRatio() : Number
    { return seekBar.mouseX / seekBarWidth }

    private function get hoveringVolumeControl() : Boolean
    { return volumeControlBounds.contains(mouseX, mouseY) }

    private function get volumeControlBounds() : Rectangle
    {
      const result : Rectangle = $volumeControlBounds

      result.inflate(10, 20)

      return result
    }

    private function get $volumeControlBounds() : Rectangle
    {
      return muteButton.getBounds(this)
        .union(volumeSlider.getBounds(this))
    }

    // -----------------------------------------------------

    private function addEventListeners() : void
    {
      onclick(largePlayButton, handlePlayButtonClicked)
      onclick(playButton, handlePlayButtonClicked)
      onclick(pauseButton, handlePauseButtonClicked)
      onclick(muteButton, handleMuteButtonClicked)
      onclick(unmuteButton, handleUnmuteButtonClicked)
      onclick(enableFullscreenButton, handleEnableFullscreenButtonClicked)
      onmousemove(seekBar, handleSeekBarMouseMove)
      onrollover(seekBar, handleSeekBarRollOver)
      onrollout(seekBar, handleSeekBarRollOut)
      onclick(seekBar, handleSeekBarClicked)
      onmousedown(volumeSlider, handleVolumeSliderMouseDown)
      onrollover(muteButton, handleVolumeButtonRollOver)
      onrollover(unmuteButton, handleVolumeButtonRollOver)
      onrollover(chrome, handleChromeRollOver)
      onrollout(chrome, handleChromeRollOut)
      onclick(rightTimeField, handleRightTimeFieldClicked)
    }

    private function handleChromeRollOver() : void
    { hoveringChrome = true, update() }

    private function handleChromeRollOut() : void
    { hoveringChrome = false, update() }

    private function handleRightTimeFieldClicked() : void
    { showRemainingTime = !showRemainingTime }

    private function handlePlayButtonClicked() : void
    { backend.handleUserPlay() }

    private function handlePauseButtonClicked() : void
    { backend.handleUserPause() }

    private function handleMuteButtonClicked() : void
    { backend.handleUserMute() }

    private function handleUnmuteButtonClicked() : void
    { backend.handleUserUnmute() }

    private function handleEnableFullscreenButtonClicked() : void
    { backend.handleUserToggleFullscreen() }

    private function handleSeekBarMouseMove() : void
    { update() }

    private function handleSeekBarRollOver() : void
    { seekBarTooltip.visible = true }

    private function handleSeekBarRollOut() : void
    { seekBarTooltip.visible = false }

    private function handleSeekBarClicked() : void
    { backend.handleUserSeek(seekBarMouseRatio) }

    private function handleVolumeSliderMouseDown() : void
    {
      changingVolume = true
      backend.handleUserSetVolume(volumeSliderMouseVolume)
      stage.addEventListener
        (MouseEvent.MOUSE_MOVE, handleVolumeSliderMouseMove);
      stage.addEventListener
        (MouseEvent.MOUSE_UP, handleVolumeSliderMouseUp);
      stage.addEventListener
        (Event.MOUSE_LEAVE, handleVolumeSliderMouseLeftStage);
    }

    private function handleVolumeSliderMouseMove(event : MouseEvent) : void
    { backend.handleUserSetVolume(volumeSliderMouseVolume) }

    private function handleVolumeSliderMouseUp(event : MouseEvent) : void
    { removeVolumeSliderEventListeners() }

    private function handleVolumeSliderMouseLeftStage(event : Event) : void
    { removeVolumeSliderEventListeners() }

    private function removeVolumeSliderEventListeners() : void
    {
      stage.removeEventListener
        (MouseEvent.MOUSE_MOVE, handleVolumeSliderMouseMove);
      stage.removeEventListener
        (MouseEvent.MOUSE_UP, handleVolumeSliderMouseUp);
      stage.removeEventListener
        (Event.MOUSE_LEAVE, handleVolumeSliderMouseLeftStage);
      changingVolume = false
    }

    private function handleVolumeButtonRollOver() : void
    { volumeSlider.visible = true }

    // -----------------------------------------------------

    protected function get seekBarWidth() : Number
    { throw new Error }

    protected function get largePlayButton() : InteractiveObject
    { return undefinedPart("largePlayButton") }
    protected function get bufferingIndicator() : InteractiveObject
    { return undefinedPart("bufferingIndicator") }

    protected function get chrome() : Sprite
    { return undefinedPart("chrome") }

    protected function get upperPanel() : Sprite
    { return undefinedPart("upperPanel") }

    protected function get titleField() : TextField
    { return undefinedPart("titleField") }

    protected function get controlBar() : Sprite
    { return undefinedPart("controlBar") }

    protected function get leftTimeField() : TextField
    { return undefinedPart("leftTimeField") }
    protected function get playButton() : DisplayObject
    { return undefinedPart("playButton") }
    protected function get pauseButton() : DisplayObject
    { return undefinedPart("pauseButton") }

    protected function get seekBarBackground() : DisplayObject
    { return undefinedPart("seekBarBackground") }

    protected function get seekBar() : Sprite
    { return undefinedPart("seekBar") }
    protected function get seekBarGroove() : DisplayObject
    { return undefinedPart("seekBarGroove") }
    protected function get seekBarBuffer() : DisplayObject
    { return undefinedPart("seekBarBuffer") }
    protected function get seekBarPlayhead() : DisplayObject
    { return undefinedPart("seekBarPlayhead") }
    protected function get seekBarTooltip() : DisplayObject
    { return undefinedPart("seekBarTooltip") }
    protected function get seekBarTooltipField() : TextField
    { return undefinedPart("seekBarTooltipField") }

    protected function get rightTimeField() : TextField
    { return undefinedPart("rightTimeField") }
    protected function get muteButton() : DisplayObject
    { return undefinedPart("muteButton") }
    protected function get unmuteButton() : DisplayObject
    { return undefinedPart("unmuteButton") }
    protected function get enableFullscreenButton() : DisplayObject
    { return undefinedPart("enableFullscreenButton") }

    protected function get volumeSlider() : Sprite
    { return undefinedPart("volumeSlider") }
    protected function get volumeSliderThumb() : DisplayObject
    { return undefinedPart("volumeSliderThumb") }
    protected function get volumeSliderThumbGuide() : DisplayObject
    { return undefinedPart("volumeSliderThumbGuide") }
    protected function get volumeSliderFill() : DisplayObject
    { return undefinedPart("volumeSliderFill") }
  }
}
