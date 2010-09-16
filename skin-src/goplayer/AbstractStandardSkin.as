package goplayer
{
  import flash.display.DisplayObject
  import flash.display.Sprite
  import flash.events.Event
  import flash.events.MouseEvent
  import flash.text.TextField

	public class AbstractStandardSkin extends AbstractSkin
  {
    private const bufferingIndicator : BufferingIndicator
      = new BufferingIndicator

    private var chromeFader : Fader
    private var largePlayButtonFader : Fader
    private var bufferingIndicatorFader : Fader

    private var hoveringChrome : Boolean = false

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

      addChildAt(bufferingIndicator, 0)

      volumeSliderFillMaxHeight = volumeSliderFill.height
      volumeSliderFillMinY = volumeSliderFill.y
      volumeSlider.mouseChildren = false
      volumeSlider.buttonMode = true

      volumeSliderThumbGuide.visible = false

      volumeSlider.visible = false

      addEventListeners()
    }

    override public function update() : void
    {
      super.update()

      titleField.text = titleText

      chromeFader.targetAlpha = showChrome ? 1 : 0

      if (chrome.alpha == 0)
        volumeSlider.visible = false

      playButton.visible = !playing
      pauseButton.visible = playing
      muteButton.visible = !muted
      unmuteButton.visible = muted

      volumeSliderThumb.y = volumeSliderThumbY
      volumeSliderFill.height = volumeSliderFillMaxHeight * volume
      volumeSliderFill.y = volumeSliderFillMinY
        + volumeSliderFillMaxHeight * (1 - volume)

      leftTimeField.text = leftTimeText
      rightTimeField.text = rightTimeText

      seekBarBackground.width = seekBarWidth
      seekBarBuffer.width = seekBarWidth * bufferRatio
      seekBarPlayhead.width = seekBarWidth * playheadRatio

      seekBarTooltip.x = seekBar.mouseX
      seekBarTooltipField.text = seekTooltipText

      largePlayButtonFader.targetAlpha = running ? 0 : 1
      bufferingIndicatorFader.targetAlpha = bufferingUnexpectedly ? 1 : 0

      if (bufferingIndicator.visible)
        bufferingIndicator.ratio = bufferFillRatio
    }

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
    }

    private function handleChromeRollOver() : void
    { hoveringChrome = true, update() }

    private function handleChromeRollOut() : void
    { hoveringChrome = false, update() }

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
    }


    private function handleVolumeButtonRollOver() : void
    { volumeSlider.visible = true }

    // -----------------------------------------------------

    protected function get seekBarWidth() : Number
    { throw new Error }

    protected function get largePlayButton() : DisplayObject
    { return undefinedPart("largePlayButton") }

    protected function get chrome() : Sprite
    { return undefinedPart("chrome") }

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

    protected function get seekBar() : Sprite
    { return undefinedPart("seekBar") }
    protected function get seekBarBackground() : DisplayObject
    { return undefinedPart("seekBarBackground") }
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
