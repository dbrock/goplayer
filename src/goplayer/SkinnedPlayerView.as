package goplayer
{
  import flash.display.Sprite
  import flash.events.Event
  import flash.events.MouseEvent
  import flash.ui.Mouse
  import flash.utils.getTimer

  public class SkinnedPlayerView extends Component
    implements PlayerVideoUpdateListener, SkinBackend
  {
    private const idleTime : Duration = Duration.seconds(2)
    private const userInteractionStopwatch : Stopwatch = new Stopwatch
    private const missingSkinParts : Array = []

    private var video : PlayerVideo
    private var player : Player
    private var skin : Skin
    private var configuration : SkinnedPlayerViewConfiguration

    private var _mousePointerVisible : Boolean = true

    public function SkinnedPlayerView
      (video : PlayerVideo,
       player : Player,
       configuration : SkinnedPlayerViewConfiguration)
    {
      this.video = video
      this.player = player
      this.skin = configuration.skin
      this.configuration = configuration

      skin.backend = this

      addChild(video)
      addChild(skin.frontend)

      video.addUpdateListener(this)

      addEventListener(Event.ADDED_TO_STAGE, handleAddedToStage)
    }

    private function handleAddedToStage(event : Event) : void
    {
      stage.addEventListener(MouseEvent.MOUSE_MOVE, handleStageMouseMove)
      stage.addEventListener(Event.MOUSE_LEAVE, handleStageMouseLeave)
    }

    private function handleStageMouseMove(event : MouseEvent) : void
    { registerInteraction() }

    private function handleStageMouseLeave(event : Event) : void
    { unregisterInteraction() }

    private function registerInteraction() : void
    { userInteractionStopwatch.start() }

    private function unregisterInteraction() : void
    { userInteractionStopwatch.reset() }

    public function handlePlayerVideoUpdated() : void
    {
      mousePointerVisible = showMousePointer
      skin.update()
    }

    private function set mousePointerVisible(value : Boolean) : void
    {
      if (value != _mousePointerVisible)
        $mousePointerVisible = value
    }

    private function set $mousePointerVisible(value : Boolean) : void
    {
      _mousePointerVisible = value

      if (value)
        Mouse.show()
      else
        Mouse.hide()
    }

    public function get showMousePointer() : Boolean
    { return !player.playing || !userIdle }

    public function get showChrome() : Boolean
    { return enableChrome && !userIdle }

    public function get enableChrome() : Boolean
    { return configuration.enableChrome }

    private function get userIdle() : Boolean
    { return !userInteractionStopwatch.within(idleTime) }

    // -----------------------------------------------------

    public function handleUserPlay() : void
    {
      if (player.finished)
        player.rewind()
      else if (player.started)
        player.paused = false
      else
        player.start()
    }

    public function handleUserPause() : void
    { player.paused = true }

    public function handleUserSeek(ratio : Number) : void
    { player.playheadRatio = ratio }

    public function handleUserMute() : void
    { player.mute() }

    public function handleUserUnmute() : void
    { player.unmute() }

    public function handleUserSetVolume(volume : Number) : void
    { player.volume = volume }

    public function handleUserToggleFullscreen() : void
    { video.toggleFullscreen() }

    public function handleUserShareViaTwitter() : void
    { player.openTwitter() }

    public function handleUserShareViaFacebook() : void
    { player.openFacebook() }

    // -----------------------------------------------------

    public function get skinWidth() : Number
    { return video.dimensions.width }

    public function get skinHeight() : Number
    { return video.dimensions.height }

    public function get skinScale() : Number
    { return video.modernFullscreenEnabled ? 2 : 1 }

    // -----------------------------------------------------

    public function get showTitle() : Boolean
    { return configuration.enableTitle }

    public function get showTwitterButton() : Boolean
    { return configuration.enableTwitterButton }

    public function get showFacebookButton() : Boolean
    { return configuration.enableFacebookButton }

    public function get showPlayPauseButton() : Boolean
    { return configuration.enablePlayPauseButton }

    public function get showElapsedTime() : Boolean
    { return configuration.enableElapsedTime }

    public function get showSeekBar() : Boolean
    { return configuration.enableSeekBar }

    public function get showTotalTime() : Boolean
    { return configuration.enableTotalTime }

    public function get showVolumeControl() : Boolean
    { return configuration.enableVolumeControl }

    public function get showFullscreenButton() : Boolean
    { return configuration.enableFullscreenButton }

    // -----------------------------------------------------

    public function get title() : String
    { return player.movie.title }

    public function get running() : Boolean
    { return player.running }

    public function get duration() : Number
    { return player.duration.seconds }

    public function get playheadRatio() : Number
    { return player.playheadRatio }

    // XXX: Maybe not a good name due to the conditional.
    public function get bufferRatio() : Number
    { return player.usingRTMP ? 0 : player.bufferRatio }

    public function get bufferFillRatio() : Number
    { return player.bufferFillRatio }

    public function get playing() : Boolean
    { return player.playing }

    public function get bufferingUnexpectedly() : Boolean
    { return player.bufferingUnexpectedly }

    public function get volume() : Number
    { return player.volume }

    // -----------------------------------------------------

    public function handleSkinPartMissing(name : String) : void
    {
      if (missingSkinParts.indexOf(name) == -1)
        $handleSkinPartMissing(name)
    }

    private function $handleSkinPartMissing(name : String) : void
    {
      debug("Error: Skin part missing: " + name)
      missingSkinParts.push(name)
    }
  }
}
