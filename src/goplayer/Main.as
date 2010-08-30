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
        = new Application(movieID, skinURL, autoplay, loop)

      addChild(application)
      setupLogger()
      application.start()
    }

    private function get movieID() : String
    { return loaderInfo.parameters.streamioMovieID }

    private function get skinURL() : String
    { return loaderInfo.parameters.skinURL }

    private function get autoplay() : Boolean
    { return "autoplay" in loaderInfo.parameters }

    private function get loop() : Boolean
    { return "loop" in loaderInfo.parameters }

    private function setupLogger() : void
    {
      if (ExternalLogger.available)
        trySetupExternalLogger()
      else
        setupInternalLogger()
    }

    private function trySetupExternalLogger() : void
    {
      try
        { setupExternalLogger() }
      catch (error : Error)
        {
          setupInternalLogger()
          debug("Error: Failed to set up external logging: " + error.message)
        }
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

      addChild(debugLayer)      
      debug("Using internal logging.")
    }
  }
}
