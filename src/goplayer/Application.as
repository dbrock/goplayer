package goplayer
{
  import flash.display.Sprite
  import flash.display.StageDisplayState
  import flash.events.MouseEvent
  import flash.events.KeyboardEvent
  import flash.external.ExternalInterface
  import flash.ui.Keyboard

  public class Application extends Sprite
    implements MovieMetadataHandler
  {
    private var dimensions : Dimensions
    private var api : StreamioAPI
    private var movieID : String
    private var autoplay : Boolean

    private var ready : Boolean = false
    private var metadata : MovieMetadata = null
    private var player : RTMPStreamPlayer = null

    public function Application
      (dimensions : Dimensions,
       api : StreamioAPI,
       movieID : String,
       autoplay : Boolean)
    {
      this.dimensions = dimensions
      this.api = api
      this.movieID = movieID
      this.autoplay = autoplay

      redraw()
      
      addEventListener(MouseEvent.CLICK, handleClick)
      addEventListener(MouseEvent.DOUBLE_CLICK, handleDoubleClick)
    }

    private function handleClick(event : MouseEvent) : void
    {
      if (ready)
        ready = false, play()
    }

    private function handleDoubleClick(event : MouseEvent) : void
    {
      stage.displayState = fullscreen
        ? StageDisplayState.NORMAL
        : StageDisplayState.FULL_SCREEN
    }

    private function handleKeyDown(event : KeyboardEvent) : void
    {
      if (event.keyCode == Keyboard.SPACE)
        player.togglePaused()
      else if (event.keyCode == Keyboard.LEFT)
        player.seek(-3)
      else if (event.keyCode == Keyboard.RIGHT)
        player.seek(+3)
      else if (event.keyCode == Keyboard.UP)
        player.changeVolume(+.1)
      else if (event.keyCode == Keyboard.DOWN)
        player.changeVolume(-.1)
    }

    private function get fullscreen() : Boolean
    { return stage.displayState == StageDisplayState.FULL_SCREEN }

    public function start() : void
    {
      stage.addEventListener(KeyboardEvent.KEY_DOWN, handleKeyDown)

      debug("Fetching metadata for Streamio movie “" + movieID + "”...")

      api.fetchMovieMetadata(movieID, this)
    }

    public function handleMovieMetadata(metadata : MovieMetadata) : void
    {
      this.metadata = metadata

      debug("Streamio movie “" + metadata.title + "” found.")

      if (autoplay)
        play()
      else
        ready = true, debug("Click to start playback.")
    }

    private function play() : void
    {
      // XXX: Select stream intelligently.
      debug("Playing last RTMP stream.")
      playRTMPStream(metadata.rtmpStreams.last)
      doubleClickEnabled = true
    }

    private function playRTMPStream(metadata : RTMPStreamMetadata) : void
    {
      player = new RTMPStreamPlayer(metadata)

      addChild(new RTMPStreamPlayerView(player))

      player.start()
    }

    private function redraw() : void
    {
      graphics.clear()
      graphics.beginFill(0x000000)
      graphics.drawRect(0, 0, dimensions.width, dimensions.height)
      graphics.endFill()
    }
  }
}
