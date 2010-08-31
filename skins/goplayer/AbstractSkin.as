package goplayer
{
	import flash.display.DisplayObject
	import flash.display.Sprite

  public class AbstractSkin extends Sprite implements Skin
  {
    private var _backend : SkinBackend = null

    public function set backend(value : SkinBackend) : void
    { _backend = value }

    public function get frontend() : DisplayObject
    { return this }

    public function update() : void
    {
      scaleX = backend.skinScale
      scaleY = backend.skinScale
    }

    // -----------------------------------------------------

    public function get backend() : SkinBackend
    { return _backend }

    protected function get skinWidth() : Number
    { return backend.skinWidth / backend.skinScale }

    protected function get skinHeight() : Number
    { return backend.skinHeight / backend.skinScale }

    protected function get playing() : Boolean
    { return backend.playing }

    protected function get volume() : Number
    { return backend.volume }

    protected function get muted() : Boolean
    { return volume == 0 }

    protected function get playheadRatio() : Number
    { return backend.playheadRatio }

    protected function get bufferRatio() : Number
    { return backend.bufferRatio }

    protected function get leftTimeText() : String
    { return getDurationByRatio(playheadRatio).mss }

    protected function get rightTimeText() : String
    { return getDurationByRatio(1 - playheadRatio).mss }

    protected function getDurationByRatio(ratio : Number) : Duration
    { return Duration.seconds(backend.streamLengthSeconds * ratio) }

    protected function lookup(name : String) : *
    {
      try
        { return SkinPartFinder.lookup(this, name.split(".")) }
      catch (error : SkinPartMissingError)
        { backend.handleSkinPartMissing(error.names.join(".")) }

      return null
    }

    protected function undefinedPart(name : String) : *
    { lookup("<undefined:" + name + ">") ; return null }
  }
}
