package goplayer
{
  import flash.display.Sprite
  import flash.display.StageDisplayState
  import flash.events.Event
  import flash.events.FullScreenEvent
  import flash.events.MouseEvent
  import flash.events.TimerEvent
  import flash.geom.Point
  import flash.geom.Rectangle
  import flash.media.Video
  import flash.utils.Timer

  public class PlayerVideo extends Sprite
  {
    private const timer : Timer = new Timer(30)
    private const screenshot : ExternalImage = new ExternalImage
    private const listeners : Array = []

    private var player : Player
    private var video : Video

    private var _dimensions : Dimensions = Dimensions.ZERO

    public function PlayerVideo
      (player : Player, video : Video)
    {
      this.player = player
      this.video = video

      addChild(screenshot)
      addChild(video)

      if (player.movie.imageURL)
        screenshot.url = player.movie.imageURL

      mouseChildren = false
      doubleClickEnabled = true

      timer.addEventListener(TimerEvent.TIMER, handleTimerEvent)
      timer.start()

      addEventListener(Event.ADDED_TO_STAGE, handleAddedToStage)
      addEventListener(MouseEvent.DOUBLE_CLICK, handleDoubleClick)

      update()
    }

    public function addUpdateListener
      (value : PlayerVideoUpdateListener) : void
    { listeners.push(value) }

    private function handleAddedToStage(event : Event) : void
    {
      stage.addEventListener
        (FullScreenEvent.FULL_SCREEN, handleFullScreenEvent)
    }

    private function handleDoubleClick(event : MouseEvent) : void
    { toggleFullscreen() }

    public function toggleFullscreen() : void
    {
      if (fullscreenEnabled)
        disableFullscreen()
      else
        enableFullscreen()
    }

    public function enableFullscreen() : void
    { stage.displayState = StageDisplayState.FULL_SCREEN }

    public function disableFullscreen() : void
    { stage.displayState = StageDisplayState.NORMAL }

    private function get fullscreenEnabled() : Boolean
    { return stage && stage.displayState == StageDisplayState.FULL_SCREEN }

    public function get dimensions() : Dimensions
    { return _dimensions }

    public function set dimensions(value : Dimensions) : void
    { _dimensions = value }

    private function handleTimerEvent(event : TimerEvent) : void
    { update() }

    private function handleFullScreenEvent(event : FullScreenEvent) : void
    { update() }

    public function update() : void
    {
      setBounds(video, videoPosition, videoDimensions)
      setBounds(screenshot, videoPosition, videoDimensions)

      video.visible = videoVisible
      video.smoothing = true

      if (stage)
        stage.fullScreenSourceRect = fullScreenSourceRect

      for each (var listener : PlayerVideoUpdateListener in listeners)
        listener.handlePlayerVideoUpdated()
    }

    public function get videoPosition() : Position
    {
      return fullscreenEnabled
        ? Position.ZERO
        : _dimensions.minus(videoDimensions).halved.asPosition
    }

    public function get videoDimensions() : Dimensions
    {
      return fullscreenEnabled
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
