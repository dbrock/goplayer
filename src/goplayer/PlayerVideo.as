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

  public class PlayerVideo extends Component
  {
    private const USE_FULL_SCREEN_SOURCE_RECT : Boolean = false

    private const timer : Timer = new Timer(30)
    private const screenshot : ExternalImage = new ExternalImage
    private const listeners : Array = []

    private var player : Player
    private var video : Video

    private var _normalDimensions : Dimensions = Dimensions.ZERO

    public function PlayerVideo
      (player : Player, video : Video)
    {
      this.player = player
      this.video = video

      video.smoothing = true

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
    }

    public function get normalDimensions() : Dimensions
    { return _normalDimensions }

    public function set normalDimensions(value : Dimensions) : void
    { _normalDimensions = value }

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

    private function handleTimerEvent(event : TimerEvent) : void
    { relayout() }

    private function handleFullScreenEvent(event : FullScreenEvent) : void
    { relayout() }

    override public function update() : void
    {
      video.visible = videoVisible

      setBounds(video, videoPosition, videoDimensions)
      setBounds(screenshot, videoPosition, videoDimensions)

      if (stage && USE_FULL_SCREEN_SOURCE_RECT)
        stage.fullScreenSourceRect = fullScreenSourceRect

      for each (var listener : PlayerVideoUpdateListener in listeners)
        listener.handlePlayerVideoUpdated()
    }

    private function get videoVisible() : Boolean
    { return player.playheadPosition.seconds > 0.1 }

    public function get videoPosition() : Position
    {
      return legacyFullscreenEnabled
        ? Position.ZERO
        : dimensions.minus(videoDimensions).halved.asPosition
    }

    private function get legacyFullscreenEnabled() : Boolean
    { return fullscreenEnabled && USE_FULL_SCREEN_SOURCE_RECT }

    public function get videoDimensions() : Dimensions
    {
      return legacyFullscreenEnabled
        ? player.highQualityDimensions
        : dimensions.getInnerDimensions(player.aspectRatio)
    }

    override public function get dimensions() : Dimensions
    {
      return legacyFullscreenEnabled ? videoDimensions
        : fullscreenEnabled ? fullscreenDimensions
        : layoutDimensions
    }

    private function get fullscreenDimensions() : Dimensions
    { return stage ? $fullscreenDimensions : layoutDimensions }

    private function get $fullscreenDimensions() : Dimensions
    { return new Dimensions(stage.fullScreenWidth, stage.fullScreenHeight) }

    private function get fullScreenSourceRect() : Rectangle
    {
      const localPoint : Point = new Point(video.x, video.y)
      const globalPoint : Point = localToGlobal(localPoint)

      return new Rectangle
        (globalPoint.x, globalPoint.y, video.width, video.height)
    }
  }
}
