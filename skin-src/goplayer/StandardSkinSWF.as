package goplayer
{
  import flash.display.Sprite

	public class StandardSkinSWF extends Sprite implements SkinSWF
  {
    public function getSkin() : Skin
    { return new ThisSkin }
  }
}
