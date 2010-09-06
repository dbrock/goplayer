package goplayer
{
  import flash.display.Sprite
  import flash.display.LoaderInfo
  import flash.events.Event

  public class Application extends Component
    implements SkinSWFLoaderListener, MovieHandler, PlayerFinishingListener
  {
    private const background : Background = new Background(0x000000, 1)
    private const contentLayer : Sprite = new Component
    internal const debugLayer : Sprite = new Component
    internal const internalLogger : InternalLogger = new InternalLogger

    private const api : StreamioAPI
      = new StreamioAPI(new StandardHTTPFetcher)

    private var configuration : Configuration

    private var keyboardHandler : ApplicationKeyboardHandler

    private var _dimensions : Dimensions = null
    private var skinSWF : SkinSWF = null
    private var movie : Movie = null
    internal var player : Player = null
    private var view : Component = null

    public function Application(configuration : Configuration)
    {
      this.configuration = configuration

      keyboardHandler = new ApplicationKeyboardHandler(this)

      debugLayer.mouseEnabled = false
      debugLayer.mouseChildren = false

      addChild(background)
      addChild(contentLayer)
      addChild(debugLayer)

      addEventListener(Event.ADDED_TO_STAGE, handleAddedToStage)
    }

    public function handleKeyDown(key : Key) : void
    { keyboardHandler.handleKeyDown(key) }

    private function handleAddedToStage(event : Event) : void
    {
      setupLogger()

      if (configuration.skinURL)
        loadSkin()
      else
        lookUpMovie()
    }

    private function setupLogger() : void
    { new ApplicationLoggerInstaller(this).execute() }

    private function loadSkin() : void
    { new SkinSWFLoader(configuration.skinURL, this).execute() }

    public function handleSkinSWFLoaded(swf : SkinSWF) : void
    {
      skinSWF = swf
      lookUpMovie()
    }

    private function lookUpMovie() : void
    {
      debug("Looking up Streamio movie “" +
            configuration.streamioMovieID + "”...")

      api.fetchMovie(configuration.streamioMovieID, this)
    }

    public function handleMovie(movie : Movie) : void
    {
      this.movie = movie

      logMovieInformation()
      createPlayer()

      if (configuration.autoplay)
        player.start()
    }

    private function logMovieInformation() : void
    {
      debug("Movie “" + movie.title + "” found.")

      const bitrates : Array = []

      for each (var stream : RTMPStream in movie.rtmpStreams)
        bitrates.push(stream.bitrate)

      if (bitrates.length == 0)
        debug("No RTMP streams available.")
      else
        debug("Available RTMP streams: " + bitrates.join(", "))
    }

    private function createPlayer() : void
    {
      const kit : PlayerKit = new PlayerKit(movie)

      player = kit.player
      player.addFinishingListener(this)

      if (skinSWF)
        view = new SkinnedPlayerView(skinSWF.getSkin(), kit.video, player)
      else
        view = new SimplePlayerView(kit.video, player)

      contentLayer.addChild(view)
    }

    private function play() : void
    { player.start() }

    public function handleMovieFinishedPlaying() : void
    {
      if (configuration.loop)
        debug("Looping."), player.rewind()
    }
  }
}
