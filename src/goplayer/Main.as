package goplayer
{
  import flash.display.Sprite
  import flash.display.StageAlign
  import flash.display.StageScaleMode

  public class Main extends Sprite
  {
    public function Main()
    {
      stage.scaleMode = StageScaleMode.NO_SCALE
      stage.align = StageAlign.TOP_LEFT

      const application : Application
        = new Application(stageDimensions, movieID, autoplay, loop)

      addChild(application)
      setupLogger()
      application.start()
    }

    private function get movieID() : String
    { return loaderInfo.parameters.streamioMovieID }

    private function get autoplay() : Boolean
    { return "autoplay" in loaderInfo.parameters }

    private function get loop() : Boolean
    { return "loop" in loaderInfo.parameters }

    private function get stageDimensions() : Dimensions
    { return new Dimensions(stage.stageWidth, stage.stageHeight) }

    private function setupLogger() : void
    {
      if (ExternalLogger.available)
        setupExternalLogger()
      else
        setupInternalLogger()
    }

    private function setupExternalLogger() : void
    {
      debugLogger = new ExternalLogger("log")
      debug("Using external logging.")
    }

    private function setupInternalLogger() : void
    {
      const debugLayer : Sprite = new Sprite

      debugLayer.mouseEnabled = false
      debugLogger = new InternalLogger(debugLayer)
      debug("External logging not available; using internal logging.")

      addChild(debugLayer)
    }
  }
}
