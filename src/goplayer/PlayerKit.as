package goplayer
{
  import flash.media.Video

  public class PlayerKit
  {
    private const flashVideo : Video = new Video
    private const connection : FlashNetConnection
      = new StandardFlashNetConnection(flashVideo)

    public var player : Player
    public var video : PlayerVideo

    public function PlayerKit
      (movie : Movie,
       bitratePolicy : BitratePolicy,
       enableRTMP : Boolean,
       reporter : MovieEventReporter,
       queue : PlayerQueue)
    {
      player = new Player
        (connection, movie, bitratePolicy, enableRTMP, reporter, queue)
      video = new PlayerVideo(player, flashVideo)
    }
  }
}
