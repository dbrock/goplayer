package goplayer
{
  public class SkinnedPlayerView extends Component
    implements PlayerVideoUpdateListener, SkinBackend
  {
    private const missingSkinParts : Array = []

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
      addChild(skin.frontend)

      video.addUpdateListener(this)
    }

    public function handlePlayerVideoUpdated() : void
    {
      video.visible = !player.finished
      skin.update()
    }

    // -----------------------------------------------------

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

    public function get bufferFillRatio() : Number
    { return player.bufferFillRatio }

    public function get playing() : Boolean
    { return player.playing }

    public function get buffering() : Boolean
    { return player.buffering }

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
