package goplayer
{
  import flash.display.Sprite
  import flash.events.Event

  public class InternalLogger extends Component implements Logger
  {
    private const MARGIN : Number = 5

    private var nextY : Number = 0

    public function InternalLogger()
    { addChild(new Background(0x000000, 0.5)) }

    public function log(message : String) : void
    {
      const line : Label = new Label
      
      line.text = message
      line.width = dimensions.width - MARGIN * 2

      line.x = MARGIN
      line.y = MARGIN + nextY

      nextY += line.height + 2

      addChild(line)
    }
  }
}
