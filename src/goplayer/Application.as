package goplayer
{
  import flash.ui.Keyboard

  public class Application extends Component
    implements SkinSWFLoaderListener, MovieHandler, PlayerListener
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

    private var _listener : ApplicationListener = null

    public function Application(parameters : Object)
    {
      installLogger()

      this.configuration = ConfigurationParser.parse(parameters)

      api = new StreamioAPI
        (configuration.apiURL,
         new StandardHTTP,
         configuration.trackerID)

      addChild(background)
      addChild(contentLayer)
      addChild(debugLayer)
    }

    public function set listener(value : ApplicationListener) : void
    { _listener = value }

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
      if (player != null)
        player.destroy()

      const kit : PlayerKit = new PlayerKit
        (movie, configuration.bitratePolicy,
         configuration.enableRTMP, api)

      player = kit.player
      player.listener = this

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
      result.enablePlayPauseButton = configuration.enablePlayPauseButton
      result.enableElapsedTime = configuration.enableElapsedTime
      result.enableSeekBar = configuration.enableSeekBar
      result.enableTotalTime = configuration.enableTotalTime
      result.enableVolumeControl = configuration.enableVolumeControl
      result.enableFullscreenButton = configuration.enableFullscreenButton

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
      else if (_listener != null)
        _listener.handlePlaybackEnded()
    }

    public function handleCurrentTimeChanged() : void
    {
      if (_listener != null)
        _listener.handleCurrentTimeChanged()
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

    public function get currentTime() : Duration
    { return player.currentTime }

    public function set currentTime(value : Duration) : void
    { player.currentTime = value }

    public function get duration() : Duration
    { return player.duration }
  }
}
