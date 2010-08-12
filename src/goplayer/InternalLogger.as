package goplayer
{
  import flash.display.DisplayObjectContainer

  public class InternalLogger implements Logger
  {
    private const MARGIN : Number = 5

    private var container : DisplayObjectContainer
    private var nextY : Number = 0

    public function InternalLogger(container : DisplayObjectContainer)
    { this.container = container }

    public function log(message : String) : void
    {
      const line : Label = new Label
      
      line.text = message

      line.x = MARGIN
      line.y = MARGIN + nextY

      nextY += line.fontSize * 1.5

      container.addChild(line)
    }
  }
}
