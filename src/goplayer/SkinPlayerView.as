package goplayer
{
  import flash.display.DisplayObject
  import flash.display.DisplayObjectContainer
  import flash.display.Sprite
  import flash.text.TextField
  import flash.events.MouseEvent
  import flash.utils.getQualifiedClassName
  import flash.utils.describeType

  public class SkinPlayerView extends ResizableSprite
    implements PlayerVideoUpdateListener
  {
    private const overlay : Background
      = new Background(0x000000, 0.5)
    private const bufferingIndicator : BufferingIndicator
      = new BufferingIndicator

    private var skin : WrappedSkin
    private var video : PlayerVideo
    private var player : Player

    public function SkinPlayerView
      (skin : WrappedSkin, video : PlayerVideo, player : Player)
    {
      this.skin = skin
      this.video = video
      this.player = player

      onclick(skin.playButton, handlePlayButtonClicked)
      onclick(skin.pauseButton, handlePauseButtonClicked)

      onclick(skin.enableFullscreenButton, handleEnableFullscreenButtonClicked)
      onclick(skin.muteButton, handleMuteButtonClicked)
      onclick(skin.unmuteButton, handleUnmuteButtonClicked)

      addChild(video)
      addChild(overlay)
      addChild(bufferingIndicator)
      addChild(skin.root)

      video.addUpdateListener(this)
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
    { video.normalDimensions = value }

    public function handlePlayerVideoUpdated() : void
    {
      setDimensions(skin.root, video.dimensions)

      skin.bufferRatio = player.bufferRatio
      skin.playheadRatio = player.playheadRatio

      video.visible = !player.finished

      skin.playButton.visible = playButtonVisible
      skin.pauseButton.visible = !playButtonVisible

      skin.muteButton.visible = !player.muted
      skin.unmuteButton.visible = player.muted

      skin.leftTimeField.text = leftTimeLabel
      skin.rightTimeField.text = rightTimeLabel

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

    private function get videoWidth() : Number
    { return video.videoDimensions.width }

    private function get videoLeft() : Number
    { return video.videoPosition.x }

    private function get videoBottom() : Number
    { return video.videoPosition.plus(video.videoDimensions).y }
  }
}
