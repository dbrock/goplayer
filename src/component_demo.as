package
{
  import flash.display.Sprite
  import flash.display.StageAlign
  import flash.display.StageScaleMode
  import flash.external.ExternalInterface

  import goplayer.GoPlayer
  import goplayer.debug

  public class component_demo extends Sprite
  {
    public function component_demo()
    {
      stage.scaleMode = StageScaleMode.NO_SCALE
      stage.align = StageAlign.TOP_LEFT

      const player : GoPlayer = new GoPlayer({
        src: "streamio:video:4c8f8267b35ea84ef4000003",
        "external-logging-function": "goplayer_demo_log",
        autoplay: true
      })

      player.width = 800
      player.height = 450

      ExternalInterface.addCallback("play", player.play)
      ExternalInterface.addCallback("pause", player.pause)
      ExternalInterface.addCallback("stop", player.stop)
      ExternalInterface.addCallback("getCurrentTime",
        function () : Number { return player.currentTime })
      ExternalInterface.addCallback("setCurrentTime",
        function (value : Number) : void { player.currentTime = value })
      ExternalInterface.addCallback("getDuration",
        function () : Number { return player.duration })

      player.ontimeupdate = function () : void { debug(player.currentTime) }
      player.onended = function () : void { debug("Recieved onended event.") }

      addChild(player)
    }
  }
}
