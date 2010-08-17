package goplayer
{
  import flash.media.Video

  public class RTMPStreamPlayerKit
  {
    private const video : Video = new Video
    private const connection : FlashNetConnection
      = new StandardFlashNetConnection(video)

    public var player : RTMPStreamPlayer
    public var view : RTMPStreamPlayerView

    public function RTMPStreamPlayerKit(metadata : RTMPStreamMetadata)
    {
      player = new RTMPStreamPlayer(metadata, connection)
      view = new RTMPStreamPlayerView(player, video)
    }
  }
}
