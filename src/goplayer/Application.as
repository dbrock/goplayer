package goplayer
{
  import flash.ui.Keyboard

  public class Application extends Component
    implements SkinSWFLoaderListener, MovieHandler, PlayerFinishingListener
  {
    private const background : Background
      = new Background(0x000000, 1)
    private const api : StreamioAPI
      = new StreamioAPI(new StandardHTTPFetcher)

    private var configuration : Configuration

    private var skinSWF : SkinSWF = null
    private var movie : Movie = null
    private var player : Player = null
    private var view : Component = null

    public function Application(configuration : Configuration)
    {
      this.configuration = configuration

      addChild(background)
    }

    override protected function initialize() : void
    {
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
      debug("Looking up Streamio movie “" + configuration.movieID + "”...")
      api.fetchMovie(configuration.movieID, this)
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
      debug("Will use " + configuration.bitratePolicy + ".")

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
      const kit : PlayerKit = new PlayerKit
        (movie, configuration.bitratePolicy)

      player = kit.player
      player.addFinishingListener(this)

      if (skinSWF)
        view = new SkinnedPlayerView(skinSWF.getSkin(), kit.video, player)
      else
        view = new SimplePlayerView(kit.video, player)

      addChild(view)
    }

    public function handleKeyDown(key : Key) : void
    {
      if (player)
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
      if (configuration.loop)
        debug("Looping."), player.rewind()
    }
  }
}
