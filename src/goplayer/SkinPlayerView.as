package goplayer
{
  import flash.display.DisplayObject
  import flash.display.DisplayObjectContainer
  import flash.display.Sprite
  import flash.text.TextField
  import flash.events.MouseEvent
  import flash.utils.getQualifiedClassName

  public class SkinPlayerView extends ResizableSprite
    implements PlayerVideoUpdateListener
  {
    private const bar : Sprite = new Sprite
    private const seekBar : Sprite = new Sprite

    private const overlay : Background
      = new Background(0x000000, 0.5)
    private const bufferingIndicator : BufferingIndicator
      = new BufferingIndicator

    private var skin : Skin
    private var video : PlayerVideo
    private var player : Player

    private var leftSide : DisplayObjectContainer
    private var rightSide : DisplayObjectContainer

    private var seekBarBackground : DisplayObjectContainer
    private var seekBarBuffer : DisplayObjectContainer
    private var seekBarPlayhead : DisplayObjectContainer

    public function SkinPlayerView
      (skin : Skin, video : PlayerVideo, player : Player)
    {
      this.skin = skin
      this.video = video
      this.player = player

      leftSide = skin.instantiate("LeftSide")
      rightSide = skin.instantiate("RightSide")

      seekBarBackground = skin.instantiate("SeekBarBackground")
      seekBarBuffer = skin.instantiate("SeekBarBuffer")
      seekBarPlayhead = skin.instantiate("SeekBarPlayhead")

      onclick(playButton, handlePlayButtonClicked)
      onclick(pauseButton, handlePauseButtonClicked)

      onclick(enableFullscreenButton, handleEnableFullscreenButtonClicked)
      onclick(muteButton, handleMuteButtonClicked)
      onclick(unmuteButton, handleUnmuteButtonClicked)

      seekBar.addChild(seekBarBackground)
      seekBar.addChild(seekBarBuffer)
      seekBar.addChild(seekBarPlayhead)

      bar.addChild(leftSide)
      bar.addChild(seekBar)
      bar.addChild(rightSide)

      addChild(video)
      addChild(overlay)
      addChild(bufferingIndicator)
      addChild(bar)

      video.addUpdateListener(this)
    }

    private function get playButton() : DisplayObject
    { return lookup(leftSide, "playButton") }

    private function get pauseButton() : DisplayObject
    { return lookup(leftSide, "pauseButton") }

    private function get muteButton() : DisplayObject
    { return lookup(rightSide, "muteButton") }

    private function get unmuteButton() : DisplayObject
    { return lookup(rightSide, "unmuteButton") }

    private function get enableFullscreenButton() : DisplayObject
    { return lookup(rightSide, "enableFullscreenButton") }

    private function get leftTimeField() : TextField
    { return lookup(leftSide, "timeLabel") }

    private function get rightTimeField() : TextField
    { return lookup(rightSide, "timeLabel") }

    private function lookup
      (container : DisplayObjectContainer, name : String) : *
    {
      const containerName : String = getQualifiedClassName(container)
      const result : DisplayObject = container.getChildByName(name)

      if (result == null)
        debug("Error: Skin part not found: " + containerName + "::" + name)

      return result
    }

    private function handlePlayButtonClicked() : void
    {
      if (player.started)
        player.paused = false
      else
        player.start()
    }

    private function handlePauseButtonClicked() : void
    { player.paused = true }

    private function handleMuteButtonClicked() : void
    { player.mute() }

    private function handleUnmuteButtonClicked() : void
    { player.unmute() }

    private function handleEnableFullscreenButtonClicked() : void
    { video.toggleFullscreen() }

    override public function set dimensions(value : Dimensions) : void
    { video.dimensions = value }

    public function handlePlayerVideoUpdated() : void
    {
      setPosition(bar, barPosition)

      leftSide.x = 0
      seekBar.x = leftSide.width
      rightSide.x = videoWidth - rightSide.width

      seekBarBackground.width = rightSide.x - seekBar.x
      seekBarBuffer.width = seekBarBackground.width * player.bufferFraction
      seekBarPlayhead.width = seekBarBackground.width * player.playheadFraction

      video.visible = !player.finished

      playButton.visible = playButtonVisible
      pauseButton.visible = !playButtonVisible

      muteButton.visible = !player.muted
      unmuteButton.visible = player.muted

      leftTimeField.text = leftTimeLabel
      rightTimeField.text = rightTimeLabel

      setBounds(overlay, video.videoPosition, video.videoDimensions)

      overlay.visible = player.buffering

      setPosition(bufferingIndicator, video.videoDimensions.halved.asPosition)

      bufferingIndicator.size = video.videoDimensions.innerSquare.width / 3
      bufferingIndicator.ratio = player.bufferFillRatio
      bufferingIndicator.visible = player.buffering

      if (bufferingIndicator.visible)
        bufferingIndicator.update()
    }

    private function get leftTimeLabel() : String
    { return player.playheadPosition.mss }

    private function get rightTimeLabel() : String
    { return player.streamLength.minus(player.playheadPosition).mss }

    private function get playButtonVisible() : Boolean
    { return !player.started || player.paused || player.finished }

    private function get barPosition() : Position
    { return new Position(videoLeft, videoBottom - bar.height + 1) }

    private function get videoWidth() : Number
    { return video.videoDimensions.width }

    private function get videoLeft() : Number
    { return video.videoPosition.x }

    private function get videoBottom() : Number
    { return video.videoPosition.plus(video.videoDimensions).y }
  }
}
