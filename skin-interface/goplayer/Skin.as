package goplayer
{
  import flash.display.DisplayObject

  public interface Skin
  {
    function set backend(value : SkinBackend) : void
    function get frontend() : DisplayObject
    function update() : void
  }
}
