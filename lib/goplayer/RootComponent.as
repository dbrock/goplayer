package goplayer
{
  import flash.display.StageAlign
  import flash.display.StageScaleMode

  public class RootComponent extends Component
  {
    public function RootComponent()
    {
      stage.scaleMode = StageScaleMode.NO_SCALE
      stage.align = StageAlign.TOP_LEFT

      onresize(stage, handleStageResized)
    }

    private function handleStageResized() : void
    { dimensions = new Dimensions(stage.stageWidth, stage.stageHeight) }
  }
}
