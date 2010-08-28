package goplayer
{
  import flash.display.DisplayObject
  import flash.text.TextField

  public class WrappedSkin
  {
    private var skin : Skin

    public function WrappedSkin(skin : Skin)
    { this.skin = skin }

    public function get root() : DisplayObject
    { return skin.skinRoot }

    public function set bufferRatio(value : Number) : void
    { skin.bufferRatio = value }

    public function set playheadRatio(value : Number) : void
    { skin.playheadRatio = value }

    public function get playButton() : DisplayObject
    { return lookup(skin.playButtonName) }

    public function get pauseButton() : DisplayObject
    { return lookup(skin.pauseButtonName) }

    public function get leftTimeField() : TextField
    { return lookup(skin.leftTimeFieldName) }

    public function get rightTimeField() : TextField
    { return lookup(skin.rightTimeFieldName) }

    public function get muteButton() : DisplayObject
    { return lookup(skin.muteButtonName) }

    public function get unmuteButton() : DisplayObject
    { return lookup(skin.unmuteButtonName) }

    public function get enableFullscreenButton() : DisplayObject
    { return lookup(skin.enableFullscreenButtonName) }

    protected function lookup(name : String) : *
    { return SkinPartFinder.lookup(root, name.split(".")) }
  }
}
