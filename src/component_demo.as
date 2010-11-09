package
{
  import flash.display.Sprite
  import flash.display.StageAlign
  import flash.display.StageScaleMode

  import goplayer.GoPlayer

  public class component_demo extends Sprite
  {
    public function component_demo()
    {
      stage.scaleMode = StageScaleMode.NO_SCALE
      stage.align = StageAlign.TOP_LEFT

      const player : GoPlayer = new GoPlayer({
        "src": "streamio:video:4c8f8267b35ea84ef4000003"
      })

      player.width = 800
      player.height = 450

      addChild(player)
    }
  }
}
