package goplayer
{
  import flash.display.Sprite
  import flash.events.TimerEvent
  import flash.geom.Rectangle
  import flash.media.Video
  import flash.net.NetStream
  import flash.utils.Timer

  public class RTMPStreamPlayerView extends Sprite
    implements RTMPStreamPlayerListener
  {
    private const video : Video = new Video
    private const timer : Timer = new Timer(30)

    private var player : RTMPStreamPlayer
    private var statusbar : RTMPStreamStatusbar

    public function RTMPStreamPlayerView(player : RTMPStreamPlayer)
    {
      this.player = player

      player.addListener(this)

      statusbar = new RTMPStreamStatusbar(player)

      addChild(video)
      addChild(statusbar)

      mouseEnabled = false
      mouseChildren = false

      update()
      
      timer.addEventListener(TimerEvent.TIMER, withoutArguments(update))
      timer.start()
    }

    public function handleRTMPStreamEstablished() : void
    { player.attachVideo(video) }

    private function update() : void
    {
      video.width = player.dimensions.width
      video.height = player.dimensions.height
      video.visible = player.playheadPosition > 0.1

      statusbar.update()

      statusbar.x = video.width - statusbar.width
      statusbar.y = video.height - statusbar.height

      if (stage)
        stage.fullScreenSourceRect
          = new Rectangle(0, 0, video.width, video.height)
    }
  }
}
