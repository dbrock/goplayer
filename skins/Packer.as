package
{
  import flash.display.DisplayObject

  public class Packer
  {
    private var base : PackItem
    private var items : Array

    public function Packer(base : PackItem, items : Array)
    { this.base = base, this.items = items }

    public function execute() : void
    {
      var current : PackItem = base

      for each (var item : PackItem in items)
        item.packLeft(current), current = item
    }

    public static function packLeft(... items : Array) : void
    {
      if (items.length > 1)
        $packLeft(importItems(items))
    }

    private static function importItems(items : Array) : Array
    {
      const result : Array = []

      for each (var item : Object in items)
        result.push(importItem(item))

      return result
    }

    private static function importItem(item : Object) : PackItem
    {
      if (item is Array)
        return new PackItem((item as Array)[0], (item as Array)[1])
      else
        return new PackItem(DisplayObject(item))
    }

    private static function $packLeft(items : Array) : void
    { new Packer(items[0], items.slice(1)).execute() }
  }
}

import flash.display.DisplayObject

class PackItem
{
  private var object : DisplayObject
  private var _width : Number

  public function PackItem(object : DisplayObject, width : Number = NaN)
  { this.object = object, _width = width }

  public function get width() : Number
  { return isNaN(_width) ? object.width : _width }

  public function get right() : Number
  { return object.x + width }

  public function packLeft(base : PackItem) : void
  { object.x = base.right }
}
