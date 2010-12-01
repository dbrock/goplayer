package goplayer
{
  public class DebugLoggerInstaller
  {
    private var functionName : String
    private var debugLayer : Component

    public function DebugLoggerInstaller
      (functionName : String, debugLayer : Component)
    { this.functionName = functionName, this.debugLayer = debugLayer }

    public function execute() : void
    {
      try
        { setupExternalLogger() }
      catch (error : Error)
        { handleExternalLoggingFailed(error) }
    }

    private function setupExternalLogger() : void
    {
      debugLogger = new ExternalLogger(functionName)
      debug("Using external logging.")
    }

    private function handleExternalLoggingFailed(error : Error) : void
    {
      setupInternalLogger()
          
      debug("Error: Failed to set up external logging: " + error.message)
      
      if (error.errorID == 2060)
        explainScriptAccess()
    }

    private function explainScriptAccess() : void
    {
      debug("If the SWF is being served from a different domain, make " +
            "sure that the SWF is embedded with the “AllowScriptAccess” " +
            "parameter set to “always”.")
      debug("If you are running locally, please make sure that the player " +
            "SWF is trusted by Flash Player; the easiest way to do so is " +
            "usually to go to the Flash Player global settings and choose " +
            "Add directory.")
    }

    private function setupInternalLogger() : void
    {
      const logger : InternalLogger = new InternalLogger

      debugLogger = logger
      debugLayer.addChild(logger)

      debug("Using internal logging: press Enter to toggle log visibility.")
    }
  }
}
