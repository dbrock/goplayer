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

    private var player : RTMPStreamPlayer = null

    public function Application
      (dimensions : Dimensions,
       api : StreamioAPI,
       movieID : String)
    {
      this.dimensions = dimensions
      this.api = api
      this.movieID = movieID

      drawBackground()
      
      doubleClickEnabled = true
      addEventListener(MouseEvent.DOUBLE_CLICK, handleDoubleClick)
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
      debug("Streamio movie “" + metadata.title + "” found; " +
            "playing last RTMP stream.")

      // XXX: Select stream intelligently.
      playRTMPStream(metadata.rtmpStreams.last)
    }

    private function playRTMPStream(metadata : RTMPStreamMetadata) : void
    {
      player = new RTMPStreamPlayer(metadata)
      player.start()

      player.mouseEnabled = false

      addChild(player)
    }

    private function drawBackground() : void
    {
      graphics.beginFill(0x000000)
      graphics.drawRect(0, 0, dimensions.width, dimensions.height)
      graphics.endFill()
    }
  }
}
