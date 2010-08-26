package goplayer
{
  import flash.events.MouseEvent

  public class DemoPlayerView extends ResizableSprite
    implements PlayerVideoUpdateListener
  {
    private const overlay : Background
      = new Background(0x000000, 0.5)
    private const bufferingIndicator : BufferingIndicator
      = new BufferingIndicator

    private var video : PlayerVideo
    private var player : Player

    private var statusbar : DemoStatusbar

    public function DemoPlayerView
      (video : PlayerVideo, player : Player)
    {
      this.video = video
      this.player = player

      statusbar = new DemoStatusbar(player)

      addChild(video)
      addChild(overlay)
      addChild(bufferingIndicator)
      addChild(statusbar)

      video.addUpdateListener(this)

      if (!player.started)
        debug("Click movie to start playback.")

      addEventListener(MouseEvent.CLICK, handleClick)
    }

    private function handleClick(event : MouseEvent) : void
    {
      if (!player.started)
        player.start()
    }

    override public function set dimensions(value : Dimensions) : void
    { video.normalDimensions = value }

    public function handlePlayerVideoUpdated() : void
    {
      statusbar.update()

      setPosition(statusbar, statusbarPosition)
      setBounds(overlay, video.videoPosition, video.videoDimensions)

      overlay.visible = player.buffering

      setPosition(bufferingIndicator, video.videoDimensions.halved.asPosition)

      bufferingIndicator.size = video.videoDimensions.innerSquare.width / 3
      bufferingIndicator.ratio = player.bufferFillRatio
      bufferingIndicator.visible = player.buffering

      if (bufferingIndicator.visible)
        bufferingIndicator.update()
    }

    private function get statusbarPosition() : Position
    { return videoFarCorner.minus(getDimensions(statusbar)) }

    private function get videoFarCorner() : Position
    { return video.videoPosition.plus(video.videoDimensions) }
  }
}
