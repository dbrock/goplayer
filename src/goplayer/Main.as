package goplayer
{
  public class Main extends RootComponent
  {
    public function Main()
    { addChild(new Application(getConfiguration())) }

    private function getConfiguration() : Configuration
    { return ConfigurationParser.parse(loaderInfo.parameters) }
  }
}
