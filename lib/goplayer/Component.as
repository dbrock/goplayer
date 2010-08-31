package goplayer
{
  import flash.display.Sprite
  import flash.display.DisplayObject

  public class Component extends Sprite
  {
    private var _implicitDimensions : Dimensions = null
    private var _explicitDimensions : Dimensions = null

    override public function addChildAt
      (child : DisplayObject, index : int) : DisplayObject
    {
      const result : DisplayObject = super.addChildAt(child, index)

      layoutChild(result)

      return result
    }

    override public function addChild(child : DisplayObject) : DisplayObject
    { return addChildAt(child, numChildren) }

    public function set position(value : Position) : void
    { setPosition(this, value) }

    public function get position() : Position
    { return getPosition(this) }

    public function set implicitDimensions(value : Dimensions) : void
    {
      if (!Dimensions.equals(value, _implicitDimensions))
        {
          _implicitDimensions = value

          if (_explicitDimensions == null)
            relayout()
        }
    }

    public function set dimensions(value : Dimensions) : void
    {
      if (!Dimensions.equals(value, _explicitDimensions))
        {
          _explicitDimensions = value
          relayout()
        }
    }

    public function get layoutDimensions() : Dimensions
    { return _explicitDimensions || _implicitDimensions }

    public function get dimensions() : Dimensions
    { return layoutDimensions }

    public function relayout() : void
    {
      if (dimensions)
        $relayout()
    }

    private function $relayout() : void
    {
      for (var i : uint = 0; i < numChildren; ++i)
        layoutChild(getChildAt(i))

      update()
    }

    private function layoutChild(child : DisplayObject) : void
    {
      if (child is Component)
        Component(child).implicitDimensions = dimensions
    }

    public function update() : void
    {}
  }
}
