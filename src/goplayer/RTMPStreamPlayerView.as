package goplayer
{
  import flash.display.Sprite
  import flash.events.Event
  import flash.geom.Rectangle
  import flash.media.Video
  import flash.net.NetStream

  public class RTMPStreamPlayerView extends Sprite
    implements RTMPStreamPlayerListener
  {
    private const video : Video = new Video

    private var player : RTMPStreamPlayer
    private var statusbar : RTMPStreamStatusbar

    public function RTMPStreamPlayerView(player : RTMPStreamPlayer)
    {
      this.player = player

      player.listener = this

      statusbar = new RTMPStreamStatusbar(player)

      addChild(video)
      addChild(statusbar)

      mouseEnabled = false
      mouseChildren = false

      update()
      
      addEventListener(Event.ENTER_FRAME, withoutArguments(update))
    }

    public function handleRTMPStreamEstablished() : void
    { player.attachVideo(video) }

    private function update() : void
    {
      video.width = player.dimensions.width
      video.height = player.dimensions.height

      statusbar.update()

      statusbar.x = video.width - statusbar.width
      statusbar.y = video.height - statusbar.height

      if (stage)
        stage.fullScreenSourceRect
          = new Rectangle(0, 0, video.width, video.height)
    }
  }
}
