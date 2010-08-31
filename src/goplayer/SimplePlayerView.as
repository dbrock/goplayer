package goplayer
{
  public class SimplePlayerView extends Component
  {
    private var video : PlayerVideo
    private var player : Player

    public function SimplePlayerView
      (video : PlayerVideo, player : Player)
    {
      this.video = video
      this.player = player

      addChild(video)

      if (!player.started)
        debug("Click movie to start playback.")

      onclick(this, handleClick)
    }

    private function handleClick() : void
    {
      if (!player.started)
        player.start()
    }
  }
}
