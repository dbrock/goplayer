package goplayer
{
  import flash.display.Sprite
  import flash.display.StageAlign
  import flash.display.StageScaleMode
  import flash.events.Event
  import flash.events.KeyboardEvent

  public class Main extends Sprite
  {
    private var application : Application

    public function Main()
    {
      stage.scaleMode = StageScaleMode.NO_SCALE
      stage.align = StageAlign.TOP_LEFT
      stage.addEventListener(Event.RESIZE, handleStageResized)
      stage.addEventListener(KeyboardEvent.KEY_DOWN, handleKeyDown)

      application = new Application(configuration)
      application.dimensions = stageDimensions

      addChild(application)
    }

    private function get configuration() : Configuration
    { return Configuration.fromParameters(loaderInfo.parameters) }

    private function handleStageResized(event : Event) : void
    { application.dimensions = stageDimensions }

    private function get stageDimensions() : Dimensions
    { return new Dimensions(stage.stageWidth, stage.stageHeight) }

    private function handleKeyDown(event : KeyboardEvent) : void
    { application.handleKeyDown(new Key(event)) }
  }
}
