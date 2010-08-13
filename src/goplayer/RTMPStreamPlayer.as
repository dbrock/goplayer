package goplayer
{
  import flash.display.Sprite
  import flash.events.Event
  import flash.geom.Rectangle
  import flash.media.Video
  import flash.net.NetStream

  public class RTMPStreamPlayer extends Sprite
  {
    private const video : Video = new Video

    private var statusbar : RTMPStreamStatusbar
    private var engine : RTMPStreamPlayerEngine

    public function RTMPStreamPlayer(metadata : RTMPStreamMetadata)
    {
      engine = new RTMPStreamPlayerEngine(metadata, this)
      statusbar = new RTMPStreamStatusbar(engine)

      addChild(video)
      addChild(statusbar)

      update()
      
      addEventListener(Event.ENTER_FRAME, withoutArguments(update))
    }

    public function start() : void
    { engine.start() }

    public function togglePaused() : void
    { engine.togglePaused() }

    public function seek(delta : Number) : void
    { engine.seek(delta) }

    public function changeVolume(delta : Number) : void
    { engine.changeVolume(delta) }

    public function handleNetStreamCreated(stream : NetStream) : void
    { video.attachNetStream(stream) }

    private function update() : void
    {
      video.width = engine.dimensions.width
      video.height = engine.dimensions.height

      statusbar.update()

      statusbar.x = video.width - statusbar.width
      statusbar.y = video.height - statusbar.height

      if (stage)
        stage.fullScreenSourceRect
          = new Rectangle(0, 0, video.width, video.height)
    }
  }
}
