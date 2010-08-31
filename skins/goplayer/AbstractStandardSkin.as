package goplayer
{
  import flash.display.DisplayObject
  import flash.display.Sprite
  import flash.events.MouseEvent
  import flash.text.TextField

	public class AbstractStandardSkin extends AbstractSkin
  {
    public function AbstractStandardSkin()
    {
      seekBarTooltip.visible = false
      seekBar.mouseChildren = false
      seekBar.buttonMode = true

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
    }

    private function get seekTooltipText() : String
    { return getDurationByRatio(seekBarMouseRatio).mss }

    private function get seekBarMouseRatio() : Number
    { return seekBar.mouseX / seekBarWidth }

    // -----------------------------------------------------

    private function addEventListeners() : void
    {
      seekBar.addEventListener
        (MouseEvent.MOUSE_MOVE, handleSeekBarMouseMove)
      seekBar.addEventListener
        (MouseEvent.ROLL_OVER, handleSeekBarRollOver)
      seekBar.addEventListener
        (MouseEvent.ROLL_OUT, handleSeekBarRollOut)
      seekBar.addEventListener
        (MouseEvent.CLICK, handleSeekBarClicked)
      playButton.addEventListener
        (MouseEvent.CLICK, handlePlayButtonClicked)
      pauseButton.addEventListener
        (MouseEvent.CLICK, handlePauseButtonClicked)
      muteButton.addEventListener
        (MouseEvent.CLICK, handleMuteButtonClicked)
      unmuteButton.addEventListener
        (MouseEvent.CLICK, handleUnmuteButtonClicked)
      enableFullscreenButton.addEventListener
        (MouseEvent.CLICK, handleEnableFullscreenButtonClicked)
    }

    private function handlePlayButtonClicked(event : MouseEvent) : void
    { backend.handleUserPlay() }

    private function handlePauseButtonClicked(event : MouseEvent) : void
    { backend.handleUserPause() }

    private function handleMuteButtonClicked(event : MouseEvent) : void
    { backend.handleUserMute() }

    private function handleUnmuteButtonClicked(event : MouseEvent) : void
    { backend.handleUserUnmute() }

    private function handleEnableFullscreenButtonClicked
      (event : MouseEvent) : void
    { backend.handleUserToggleFullscreen() }

    private function handleSeekBarMouseMove(event : MouseEvent) : void
    { update() }

    private function handleSeekBarRollOver(event : MouseEvent) : void
    { seekBarTooltip.visible = true }

    private function handleSeekBarRollOut(event : MouseEvent) : void
    { seekBarTooltip.visible = false }

    private function handleSeekBarClicked(event : MouseEvent) : void
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
