package goplayer
{
  import flash.display.Sprite
  import flash.events.TimerEvent
  import flash.geom.Rectangle
  import flash.media.Video
  import flash.net.NetStream
  import flash.utils.Timer

  public class RTMPStreamPlayerView extends Sprite
  {
    private const timer : Timer = new Timer(30)

    private var player : RTMPStreamPlayer
    private var video : Video

    private var statusbar : RTMPStreamStatusbar

    public function RTMPStreamPlayerView
      (player : RTMPStreamPlayer, video : Video)
    {
      this.player = player
      this.video = video

      statusbar = new RTMPStreamStatusbar(player)

      addChild(video)
      addChild(statusbar)

      mouseEnabled = false
      mouseChildren = false

      timer.addEventListener(TimerEvent.TIMER, handleTimerEvent)
      timer.start()

      update()
    }

    private function handleTimerEvent(event : TimerEvent) : void
    { update() }

    public function update() : void
    {
      video.width = player.dimensions.width
      video.height = player.dimensions.height
      video.visible = player.playheadPosition.seconds > 0.1

      statusbar.update()

      statusbar.x = video.width - statusbar.width
      statusbar.y = video.height - statusbar.height

      if (stage)
        stage.fullScreenSourceRect
          = new Rectangle(0, 0, video.width, video.height)
    }
  }
}
