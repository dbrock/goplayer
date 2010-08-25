package goplayer
{
  import flash.display.Sprite

  public class DemoPlayerView extends Sprite
    implements PlayerViewUpdateListener
  {
    private const overlay : Background
      = new Background(0x000000, 0.5)
    private const bufferingIndicator : BufferingIndicator
      = new BufferingIndicator

    private var view : PlayerView
    private var player : Player

    private var statusbar : PlayerStatusbar

    public function DemoPlayerView(view : PlayerView, player : Player)
    {
      this.view = view
      this.player = player

      statusbar = new PlayerStatusbar(player)

      addChild(view)
      addChild(overlay)
      addChild(bufferingIndicator)
      addChild(statusbar)

      view.addUpdateListener(this)
    }

    public function set dimensions(value : Dimensions) : void
    { view.dimensions = value }

    public function handlePlayerViewUpdated() : void
    {
      statusbar.update()

      setPosition(statusbar, statusbarPosition)
      setBounds(overlay, view.videoPosition, view.videoDimensions)

      overlay.visible = player.buffering

      setPosition(bufferingIndicator, view.videoDimensions.halved.asPosition)

      bufferingIndicator.size = view.videoDimensions.innerSquare.width / 3
      bufferingIndicator.ratio = player.bufferFillRatio
      bufferingIndicator.visible = player.buffering

      if (bufferingIndicator.visible)
        bufferingIndicator.update()
    }

    private function get statusbarPosition() : Position
    {
      return view.videoPosition.plus(view.videoDimensions)
        .minus(getDimensions(statusbar))
    }
  }
}
