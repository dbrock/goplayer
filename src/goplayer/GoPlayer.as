package goplayer
{
  import flash.display.Sprite
  import flash.events.Event

  public class GoPlayer extends Component
  {
    private var application : Application
    private var _width : Number
    private var _height : Number

    public function GoPlayer(parameters : Object)
    {
      application = new Application(ConfigurationParser.parse(parameters))

      addEventListener(Event.ADDED_TO_STAGE, handleAddedToStage)

      addChild(application)
    }

    override public function set width(value : Number) : void
    { _width = value, maybeResize() }

    override public function set height(value : Number) : void
    { _height = value, maybeResize() }

    private function maybeResize() : void
    {
      if (!isNaN(_width) && !isNaN(_height))
        dimensions = new Dimensions(_width, _height)
    }

    private function handleAddedToStage(event : Event) : void
    { onkeydown(stage, application.handleKeyDown) }
  }
}
