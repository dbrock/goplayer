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
      line.width = container.stage.stageWidth - MARGIN * 2

      line.x = MARGIN
      line.y = MARGIN + nextY

      nextY += line.height + 2

      container.addChild(line)
    }
  }
}
