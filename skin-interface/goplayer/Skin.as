package goplayer
{
  import flash.display.DisplayObject

  public interface Skin
  {
    function set width(value : Number) : void
    function set height(value : Number) : void

    function set bufferRatio(value : Number) : void
    function set playheadRatio(value : Number) : void

    function get skinRoot() : DisplayObject

    function get playButtonName() : String
    function get pauseButtonName() : String
    function get leftTimeFieldName() : String
    function get rightTimeFieldName() : String
    function get muteButtonName() : String
    function get unmuteButtonName() : String
    function get enableFullscreenButtonName() : String
  }
}
