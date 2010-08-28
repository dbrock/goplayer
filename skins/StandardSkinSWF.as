package
{
  import flash.display.Sprite

  import goplayer.Skin
  import goplayer.SkinSWF

	public class StandardSkinSWF extends Sprite implements SkinSWF
  {
    public function getSkin() : Skin
    { return new Root }
  }
}
