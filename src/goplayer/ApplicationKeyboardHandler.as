package goplayer
{
  import flash.events.KeyboardEvent
  import flash.ui.Keyboard

  public class ApplicationKeyboardHandler
  {
    private var application : Application

    public function ApplicationKeyboardHandler(application : Application)
    { this.application = application }

    public function handleKeyDown(key : Key) : void
    {
      if (key.code == Keyboard.ENTER)
        application.debugLayer.visible = !application.debugLayer.visible
      else if (application.player)
        handlePlayerKeyDown(key)
    }

    private function handlePlayerKeyDown(key : Key) : void
    {
      if (key.code == Keyboard.SPACE)
        application.player.togglePaused()
      else if (key.code == Keyboard.LEFT)
        application.player.seekBy(Duration.seconds(-3))
      else if (key.code == Keyboard.RIGHT)
        application.player.seekBy(Duration.seconds(+3))
      else if (key.code == Keyboard.UP)
        application.player.changeVolumeBy(+.1)
      else if (key.code == Keyboard.DOWN)
        application.player.changeVolumeBy(-.1)
    }
  }
}
