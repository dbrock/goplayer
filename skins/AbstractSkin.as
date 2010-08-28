package
{
	import flash.display.DisplayObject
	import flash.display.Sprite

  import goplayer.Skin

  public class AbstractSkin extends Sprite implements Skin
  {
    private var _width : Number = NaN
    private var _height : Number = NaN
    private var _bufferRatio : Number = NaN
    private var _playheadRatio : Number = NaN

    override public function get width() : Number
    { return _width }

    override public function set width(value : Number) : void
    { _width = value, update() }

    override public function get height() : Number
    { return _height }

    override public function set height(value : Number) : void
    { _height = value, update() }

    public function get bufferRatio() : Number
    { return _bufferRatio }

    public function set bufferRatio(value : Number) : void
    { _bufferRatio = value, update() }

    public function get playheadRatio() : Number
    { return _playheadRatio }

    public function set playheadRatio(value : Number) : void
    { _playheadRatio = value, update() }

    protected function update() : void
    {}

    public function get skinRoot() : DisplayObject
    { return this }

    public function get playButtonName() : String
    { return "playButton" }

    public function get pauseButtonName() : String
    { return "pauseButton" }

    public function get leftTimeFieldName() : String
    { return "leftTimeField" }

    public function get rightTimeFieldName() : String
    { return "rightTimeField" }

    public function get muteButtonName() : String
    { return "muteButton" }

    public function get unmuteButtonName() : String
    { return "unmuteButton" }

    public function get enableFullscreenButtonName() : String
    { return "enableFullscreenButton" }
  }
}
