package goplayer
{
  import flash.text.TextField
  import flash.text.TextFormat
  import flash.text.TextFieldAutoSize

  public class Label extends TextField
  {
    private const format : TextFormat = new TextFormat

    public function Label()
    {
      format.color = 0xffffff
      format.size = 14
      format.font = "Consolas"
      format.leading = 0

      autoSize = TextFieldAutoSize.LEFT
    }

    override public function set text(value : String) : void
    {
      super.text = value

      setTextFormat(format)
    }

    public function get fontSize() : Number
    { return Number(format.size) }

    public function get dimensions() : Dimensions
    { return new Dimensions(width, height) }
  }
}
