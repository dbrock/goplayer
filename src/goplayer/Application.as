package goplayer
{
  import flash.display.Sprite
  import flash.external.ExternalInterface

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
    }

    public function start() : void
    {
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
