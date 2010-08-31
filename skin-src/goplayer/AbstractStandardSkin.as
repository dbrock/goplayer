package goplayer
{
  import flash.display.DisplayObject
  import flash.display.Sprite
  import flash.text.TextField

	public class AbstractStandardSkin extends AbstractSkin
  {
    private const bufferingIndicator : BufferingIndicator
      = new BufferingIndicator

    public function AbstractStandardSkin()
    {
      seekBarTooltip.visible = false
      seekBar.mouseChildren = false
      seekBar.buttonMode = true

      addChild(bufferingIndicator)

      addEventListeners()
    }

    override public function update() : void
    {
      super.update()

      playButton.visible = !playing
      pauseButton.visible = playing
      muteButton.visible = !muted
      unmuteButton.visible = muted

      leftTimeField.text = leftTimeText
      rightTimeField.text = rightTimeText

      seekBarBackground.width = seekBarWidth
      seekBarBuffer.width = seekBarWidth * bufferRatio
      seekBarPlayhead.width = seekBarWidth * playheadRatio

      seekBarTooltip.x = seekBar.mouseX
      seekBarTooltipField.text = seekTooltipText

      bufferingIndicator.visible = buffering

      if (bufferingIndicator.visible)
        bufferingIndicator.ratio = bufferFillRatio
    }

    private function get seekTooltipText() : String
    { return getDurationByRatio(seekBarMouseRatio).mss }

    private function get seekBarMouseRatio() : Number
    { return seekBar.mouseX / seekBarWidth }

    // -----------------------------------------------------

    private function addEventListeners() : void
    {
      onclick(playButton, handlePlayButtonClicked)
      onclick(pauseButton, handlePauseButtonClicked)
      onclick(muteButton, handleMuteButtonClicked)
      onclick(unmuteButton, handleUnmuteButtonClicked)
      onclick(enableFullscreenButton, handleEnableFullscreenButtonClicked)
      onmousemove(seekBar, handleSeekBarMouseMove)
      onrollover(seekBar, handleSeekBarRollOver)
      onrollout(seekBar, handleSeekBarRollOut)
      onclick(seekBar, handleSeekBarClicked)
    }

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

    // -----------------------------------------------------

    protected function get seekBarWidth() : Number
    { throw new Error }

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
  }
}
