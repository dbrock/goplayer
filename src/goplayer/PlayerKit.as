package goplayer
{
  import flash.media.Video

  public class PlayerKit
  {
    private const video : Video = new Video
    private const connection : FlashNetConnection
      = new StandardFlashNetConnection(video)

    public var player : Player
    public var view : PlayerView

    public function PlayerKit(movie : Movie)
    {
      player = new Player(movie, connection)
      view = new PlayerView(player, video)
    }
  }
}
