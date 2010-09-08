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
    private const IDLE_TIME_MS : uint = 2000

    private const missingSkinParts : Array = []

    private var skin : Skin
    private var video : PlayerVideo
    private var player : Player
    private var chromeEnabled : Boolean

    private var lastInteractionTime : uint = 0

    public function SkinnedPlayerView
      (skin : Skin,
       video : PlayerVideo,
       player : Player,
       chromeEnabled : Boolean)
    {
      this.skin = skin
      this.video = video
      this.player = player
      this.chromeEnabled = chromeEnabled

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

    private function registerInteraction() : void
    { lastInteractionTime = getTimer() }

    private function handleStageMouseLeave(event : Event) : void
    { lastInteractionTime = 0 }

    public function handlePlayerVideoUpdated() : void
    {
      if (!player.playing)
        registerInteraction()

      if (showMousePointer)
        Mouse.show()
      else
        Mouse.hide()

      skin.update()
    }

    public function get showMousePointer() : Boolean
    { return !player.playing || !userIdle }

    public function get showChrome() : Boolean
    { return chromeEnabled && showMousePointer }

    private function get userIdle() : Boolean
    { return getTimer() - lastInteractionTime > IDLE_TIME_MS }

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

    // -----------------------------------------------------

    public function get skinWidth() : Number
    { return video.dimensions.width }

    public function get skinHeight() : Number
    { return video.dimensions.height }

    public function get skinScale() : Number
    { return video.modernFullscreenEnabled ? 2 : 1 }

    public function get title() : String
    { return player.movie.title }

    public function get running() : Boolean
    { return player.running }

    public function get streamLengthSeconds() : Number
    { return player.streamLength.seconds }

    public function get playheadRatio() : Number
    { return player.playheadRatio }

    public function get bufferRatio() : Number
    { return player.bufferRatio }

    public function get bufferFillRatio() : Number
    { return player.bufferFillRatio }

    public function get playing() : Boolean
    { return player.playing }

    public function get buffering() : Boolean
    { return player.buffering }

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
