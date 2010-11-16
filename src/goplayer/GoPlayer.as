// This class is intended to be used for embedding Go Player as a
// component in other ActionScript projects.

package goplayer
{
  import flash.display.Sprite
  import flash.events.Event

  public class GoPlayer extends Component implements ApplicationListener
  {
    private var application : Application

    private var _width : Number
    private var _height : Number

    private var _ontimeupdate : Function = null
    private var _onended : Function = null

    public function GoPlayer(parameters : Object)
    {
      application = new Application(parameters)
      application.listener = this
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

    public function play() : void
    { application.play() }

    public function pause() : void
    { application.pause() }

    public function stop() : void
    { application.stop() }

    public function get currentTime() : Number
    { return application.currentTime.seconds }

    public function set currentTime(value : Number) : void
    { application.currentTime = Duration.seconds(value) }

    public function get duration() : Number
    { return application.duration.seconds }

    public function set ontimeupdate(value : Function) : void
    { _ontimeupdate = value }

    public function set onended(value : Function) : void
    { _onended = value }

    public function handleCurrentTimeChanged() : void
    {
      if (_ontimeupdate != null)
        _ontimeupdate()
    }

    public function handlePlaybackEnded() : void
    {
      if (_onended != null)
        _onended()
    }
  }
}
