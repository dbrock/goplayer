package goplayer
{
  import flash.display.Sprite
  import flash.events.Event
  import flash.events.FullScreenEvent
  import flash.events.TimerEvent
  import flash.geom.Point
  import flash.geom.Rectangle
  import flash.media.Video
  import flash.net.NetStream
  import flash.utils.Timer

  public class PlayerView extends Sprite
  {
    private const timer : Timer = new Timer(30)
    private const screenshot : ExternalImage = new ExternalImage
    private const videoContainer : Sprite = new Sprite
    private const overlay : Background
      = new Background(0x000000, 0.5)
    private const bufferingIndicator : BufferingIndicator
      = new BufferingIndicator

    private var player : Player
    private var video : Video

    private var statusbar : PlayerStatusbar

    private var _dimensions : Dimensions = Dimensions.ZERO
    private var fullscreen : Boolean = false

    public function PlayerView
      (player : Player, video : Video)
    {
      this.player = player
      this.video = video

      statusbar = new PlayerStatusbar(player)

      videoContainer.addChild(screenshot)
      videoContainer.addChild(video)
      videoContainer.addChild(overlay)
      videoContainer.addChild(bufferingIndicator)
      videoContainer.addChild(statusbar)

      addChild(videoContainer)

      if (player.movie.imageURL)
        screenshot.url = player.movie.imageURL

      mouseEnabled = false
      mouseChildren = false

      timer.addEventListener(TimerEvent.TIMER, handleTimerEvent)
      timer.start()

      addEventListener(Event.ADDED_TO_STAGE, handleAddedToStage)

      update()
    }

    private function handleAddedToStage(event : Event) : void
    {
      stage.addEventListener
        (FullScreenEvent.FULL_SCREEN, handleFullScreenEvent)
    }

    public function set dimensions(value : Dimensions) : void
    { _dimensions = value }

    private function handleTimerEvent(event : TimerEvent) : void
    { update() }

    private function handleFullScreenEvent(event : FullScreenEvent) : void
    { fullscreen = event.fullScreen, update() }

    public function update() : void
    {
      videoContainer.x = videoPosition.x
      videoContainer.y = videoPosition.y

      video.width = videoDimensions.width
      video.height = videoDimensions.height

      screenshot.width = videoDimensions.width
      screenshot.height = videoDimensions.height

      video.visible = videoVisible
      video.smoothing = true

      statusbar.update()

      statusbar.x = video.x + video.width - statusbar.width
      statusbar.y = video.y + video.height - statusbar.height

      overlay.dimensions = videoDimensions
      overlay.visible = player.buffering || player.paused

      bufferingIndicator.x = videoDimensions.width / 2
      bufferingIndicator.y = videoDimensions.height / 2

      bufferingIndicator.size = videoDimensions.innerSquare.width / 3
      bufferingIndicator.ratio = player.bufferFillRatio
      bufferingIndicator.visible = player.buffering

      if (bufferingIndicator.visible)
        bufferingIndicator.update()

      if (stage)
        stage.fullScreenSourceRect = fullScreenSourceRect
    }

    private function get videoPosition() : Position
    {
      return fullscreen
        ? Position.ZERO
        : _dimensions.minus(videoDimensions).halved.asPosition
    }

    private function get videoDimensions() : Dimensions
    {
      return fullscreen
        ? player.highQualityDimensions
        : _dimensions.getInnerDimensions(player.aspectRatio)
    }

    private function get videoVisible() : Boolean
    { return player.playheadPosition.seconds > 0.1 }

    private function get fullScreenSourceRect() : Rectangle
    {
      const localPoint : Point = new Point(video.x, video.y)
      const globalPoint : Point = localToGlobal(localPoint)

      return new Rectangle
        (globalPoint.x, globalPoint.y, video.width, video.height)
    }
  }
}
