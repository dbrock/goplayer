package goplayer
{
  import flash.display.DisplayObject
  import flash.display.Sprite
  import flash.events.Event
  import flash.text.TextField
  import flash.text.TextFieldAutoSize
  import flash.text.TextFormat

  public class InternalLogger extends Component implements Logger
  {
    private const MARGIN : Number = 5

    private var nextY : Number = 0

    public function InternalLogger()
    { addChild(new Background(0x000000, 0.5)) }

    public function log(message : String) : void
    {
      const line : DisplayObject = getLine(message)
      
      line.x = MARGIN
      line.y = MARGIN + nextY

      nextY += line.height + 2

      addChild(line)
    }

    public function getLine(text : String) : DisplayObject
    {
      const result : TextField = new TextField
      const format : TextFormat = new TextFormat

      result.text = text
      result.autoSize = TextFieldAutoSize.LEFT
      result.multiline = true
      result.wordWrap = true
      result.width = dimensions.width - MARGIN * 2

      format.color = 0xffffff
      format.size = 11
      format.font = "Verdana"
      format.leading = 0

      result.setTextFormat(format)

      return result
    }
  }
}
