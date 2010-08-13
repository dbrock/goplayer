package goplayer
{
  import flash.display.Sprite
  import flash.display.StageAlign
  import flash.display.StageScaleMode

  public class Main extends Sprite
  {
    private const debugLayer : Sprite = new Sprite

    public function Main()
    {
      stage.scaleMode = StageScaleMode.NO_SCALE
      stage.align = StageAlign.TOP_LEFT

      debugLogger = new InternalLogger(debugLayer)

      const application : Application
        = new Application(stageDimensions, api, movieID)

      addChild(application)
      addChild(debugLayer)

      debugLayer.mouseEnabled = false

      application.start()
    }

    private function get api() : StreamioAPI
    { return new StreamioAPI(new StandardHTTPFetcher) }

    private function get movieID() : String
    { return loaderInfo.parameters.StreamioMovieID }

    private function get stageDimensions() : Dimensions
    { return new Dimensions(stage.stageWidth, stage.stageHeight) }
  }
}
