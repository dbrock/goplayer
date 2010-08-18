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

      screenshot.url = player.movie.imageURL

      videoContainer.addChild(screenshot)
      videoContainer.addChild(video)
      videoContainer.addChild(statusbar)

      addChild(videoContainer)

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
