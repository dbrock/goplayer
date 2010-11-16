package goplayer
{
  public class Main extends RootComponent
  {
    public function Main()
    { addChild(new Application(loaderInfo.parameters)) }
  }
}
