package goplayer
{
  import flash.display.Sprite
  import flash.display.LoaderInfo
  import flash.events.Event
  import flash.events.KeyboardEvent
  import flash.ui.Keyboard

  public class Application extends Sprite
    implements SkinSWFLoaderListener, MovieHandler, PlayerFinishingListener
  {
    private const api : StreamioAPI
      = new StreamioAPI(new StandardHTTPFetcher)

    private var movieID : String
    private var skinURL : String
    private var autoplay : Boolean
    private var loop : Boolean

    private var skinSWF : SkinSWF = null
    private var movie : Movie = null
    private var player : Player = null
    private var view : ResizableSprite = null

    public function Application
      (movieID : String,
       skinURL : String,
       autoplay : Boolean,
       loop : Boolean)
    {
      this.movieID = movieID
      this.skinURL = skinURL
      this.autoplay = autoplay
      this.loop = loop
    }

    public function start() : void
    {
      drawBackground()

      stage.addEventListener(KeyboardEvent.KEY_DOWN, handleKeyDown)
      stage.addEventListener(Event.RESIZE, handleStageResized)

      if (skinURL)
        loadSkin()
      else
        lookUpMovie()
    }

    private function loadSkin() : void
    { new SkinSWFLoader(skinURL, this).execute() }

    public function handleSkinSWFLoaded(swf : SkinSWF) : void
    {
      skinSWF = swf
      lookUpMovie()
    }

    private function lookUpMovie() : void
    {
      debug("Looking up Streamio movie “" + movieID + "”...")
      api.fetchMovie(movieID, this)
    }

    private function drawBackground() : void
    {
      graphics.beginFill(0x000000)
      graphics.drawRect(0, 0, stageDimensions.width, stageDimensions.height)
      graphics.endFill()
    }

    private function handleKeyDown(event : KeyboardEvent) : void
    {
      if (!player) return

      if (event.keyCode == Keyboard.SPACE)
        player.togglePaused()
      else if (event.keyCode == Keyboard.LEFT)
        player.seekBy(Duration.seconds(-3))
      else if (event.keyCode == Keyboard.RIGHT)
        player.seekBy(Duration.seconds(+3))
      else if (event.keyCode == Keyboard.UP)
        player.changeVolumeBy(+.1)
      else if (event.keyCode == Keyboard.DOWN)
        player.changeVolumeBy(-.1)
    }

    private function handleStageResized(event : Event) : void
    {
      if (view)
        view.dimensions = stageDimensions
    }

    public function handleMovie(movie : Movie) : void
    {
      this.movie = movie

      logMovieInformation()
      createPlayer()

      if (autoplay)
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
        view = new SkinPlayerView(getSkin(), kit.video, player)
      else
        view = new DemoPlayerView(kit.video, player)

      view.dimensions = stageDimensions

      addChild(view)
    }

    private function getSkin() : WrappedSkin
    { return new WrappedSkin(skinSWF.getSkin()) }

    private function get stageDimensions() : Dimensions
    { return new Dimensions(stage.stageWidth, stage.stageHeight) }

    private function play() : void
    { player.start() }

    public function handleMovieFinishedPlaying() : void
    {
      if (loop)
        debug("Looping."), player.rewind()
    }
  }
}
