package goplayer
{
  import flash.ui.Keyboard

  public class Main extends RootComponent
  {
    private const debugLayer : Component = new EphemeralComponent

    private var application : Application

    public function Main()
    {
      installLogger()

      application = new Application(getConfiguration())

      addChild(application)
      addChild(debugLayer)

      onkeydown(stage, handleKeyDown)
    }

    private function installLogger() : void
    { new DebugLoggerInstaller(debugLayer).execute() }

    private function getConfiguration() : Configuration
    { return Configuration.fromParameters(loaderInfo.parameters) }

    private function handleKeyDown(key : Key) : void
    {
      if (key.code == Keyboard.ENTER)
        debugLayer.visible = !debugLayer.visible
      else
        application.handleKeyDown(key)
    }
  }
}
