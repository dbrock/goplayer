package goplayer
{
  import flash.ui.Keyboard

  public class Application extends Component
    implements SkinSWFLoaderListener, MovieHandler, PlayerFinishingListener
  {
    private const background : Background
      = new Background(0x000000, 1)
    private const contentLayer : Component
      = new Component
    private const debugLayer : Component
      = new EphemeralComponent

    private var configuration : Configuration

    private var api : StreamioAPI

    private var skinSWF : SkinSWF = null
    private var movie : Movie = null
    private var player : Player = null
    private var view : Component = null

    public function Application(configuration : Configuration)
    {
      this.configuration = configuration

      api = new StreamioAPI
        (configuration.apiURL,
         new StandardHTTP,
         configuration.trackerID)

      addChild(background)
      addChild(contentLayer)
      addChild(debugLayer)

      installLogger()
    }

    private function installLogger() : void
    { new DebugLoggerInstaller(debugLayer).execute() }

    override protected function initialize() : void
    {
      onkeydown(stage, handleKeyDown)

      if (configuration.skinURL)
        loadSkin()
      else
        lookUpMovie()
    }

    private function loadSkin() : void
    { new SkinSWFLoader(configuration.skinURL, this).execute() }

    public function handleSkinSWFLoaded(swf : SkinSWF) : void
    {
      skinSWF = swf
      lookUpMovie()
    }

    private function lookUpMovie() : void
    {
      debug("Looking up Streamio video “" + configuration.movieID + "”...")
      api.fetchMovie(configuration.movieID, this)
    }

    public function handleMovie(movie : Movie) : void
    {
      this.movie = movie

      logMovieInformation()
      createPlayer()

      if (configuration.enableAutoplay)
        player.start()
    }

    private function logMovieInformation() : void
    {
      debug("Movie “" + movie.title + "” found.")
      debug("Will use " + configuration.bitratePolicy + ".")

      const bitrates : Array = []

      for each (var stream : RTMPStream in movie.rtmpStreams)
        bitrates.push(stream.bitrate)

      if (bitrates.length == 0)
        debug("No RTMP streams available.")
      else
        debug("Available RTMP streams: " + bitrates.join(", "))

      if (!configuration.enableRTMP)
        debug("Will not use RTMP (disabled by configuration).")
    }

    private function createPlayer() : void
    {
      const kit : PlayerKit = new PlayerKit
        (movie, configuration.bitratePolicy,
         configuration.enableRTMP, api)

      player = kit.player
      player.addFinishingListener(this)

      if (skinSWF)
        view = new SkinnedPlayerView(kit.video, player, viewConfiguration)
      else
        view = new SimplePlayerView(kit.video, player)

      contentLayer.addChild(view)
    }

    private function get viewConfiguration() : SkinnedPlayerViewConfiguration
    {
      const result : SkinnedPlayerViewConfiguration
        = new SkinnedPlayerViewConfiguration

      result.skin = skinSWF.getSkin()
      result.enableChrome = configuration.enableChrome
      result.enableTitle = configuration.enableTitle

      return result
    }

    public function handleKeyDown(key : Key) : void
    {
      if (key.code == Keyboard.ENTER)
        debugLayer.visible = !debugLayer.visible
      else if (player != null)
        $handleKeyDown(key)
    }

    private function $handleKeyDown(key : Key) : void
    {
      if (key.code == Keyboard.SPACE)
        player.togglePaused()
      else if (key.code == Keyboard.LEFT)
        player.seekBy(Duration.seconds(-3))
      else if (key.code == Keyboard.RIGHT)
        player.seekBy(Duration.seconds(+3))
      else if (key.code == Keyboard.UP)
        player.changeVolumeBy(+.1)
      else if (key.code == Keyboard.DOWN)
        player.changeVolumeBy(-.1)
    }

    public function handleMovieFinishedPlaying() : void
    {
      if (configuration.enableLooping)
        debug("Looping."), player.rewind()
    }

    public function play() : void
    {
      if (player != null)
        $play()
    }

    private function $play() : void
    {
      if (player.started)
        player.paused = false
      else
        player.start()
    }

    public function pause() : void
    {
      if (player != null)
        player.paused = true
    }

    public function stop() : void
    {
      if (player != null)
        player.stop()
    }

    public function get playheadPosition() : Duration
    { return player.playheadPosition }

    public function set playheadPosition(value : Duration) : void
    { player.playheadPosition = value }

    public function get streamLength() : Duration
    { return player.streamLength }
  }
}
