package goplayer
{
  public class SkinnedPlayerView extends Component
    implements PlayerVideoUpdateListener, SkinBackend
  {
    private const missingSkinParts : Array = []
    private const overlay : Background
      = new Background(0x000000, 0.5)
    private const bufferingIndicator : BufferingIndicator
      = new BufferingIndicator

    private var skin : Skin
    private var video : PlayerVideo
    private var player : Player

    public function SkinnedPlayerView
      (skin : Skin, video : PlayerVideo, player : Player)
    {
      this.skin = skin
      this.video = video
      this.player = player

      skin.backend = this

      addChild(video)
      addChild(overlay)
      addChild(bufferingIndicator)
      addChild(skin.frontend)

      skin.frontend.visible = false

      video.addUpdateListener(this)
    }

    public function handleUserPlay() : void
    {
      if (player.started)
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

    public function handleUserToggleFullscreen() : void
    { video.toggleFullscreen() }

    // -----------------------------------------------------

    public function get skinWidth() : Number
    { return video.dimensions.width }

    public function get skinHeight() : Number
    { return video.dimensions.height }

    public function get skinScale() : Number
    { return video.fullscreenEnabled ? 2 : 1 }

    public function get streamLengthSeconds() : Number
    { return player.streamLength.seconds }

    public function get playheadRatio() : Number
    { return player.playheadRatio }

    public function get bufferRatio() : Number
    { return player.bufferRatio }

    public function get playing() : Boolean
    { return player.playing }

    public function get volume() : Number
    { return player.volume }

    public function getTimeStringByRatio(ratio : Number) : String
    { return player.streamLength.scaledBy(ratio).mss }

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

    // -----------------------------------------------------

    public function handlePlayerVideoUpdated() : void
    {
      updateVideo()
      updateOverlay()
      updateSkin()
    }

    private function updateVideo() : void
    { video.visible = !player.finished }

    private function updateOverlay() : void
    {
      overlay.visible = player.buffering
      bufferingIndicator.visible = player.buffering

      if (player.buffering)
        updateBufferingIndicator()
    }

    private function updateBufferingIndicator() :void
    {
      setPosition(bufferingIndicator, video.videoCenter)
      bufferingIndicator.size = video.videoDimensions.innerSquare.width / 3
      bufferingIndicator.ratio = player.bufferFillRatio
      bufferingIndicator.update()
    }

    private function updateSkin() : void
    {
      skin.update()

      // If the skin could be updated, show it.
      skin.frontend.visible = true
    }
  }
}
