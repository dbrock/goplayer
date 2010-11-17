package goplayer
{
  import flash.display.DisplayObject

  public class Packer
  {
    private var base : Item
    private var items : Array

    public function Packer(base : Item, items : Array)
    { this.base = base, this.items = items }

    public function execute() : void
    {
      var current : Item = base

      for each (var item : Item in items)
        item.packLeft(current), current = item
    }

    public static function packLeft(space : Number, ... items : Array) : void
    { $packLeft(space, items) }

    public static function $packLeft(space : Number, items : Array) : void
    {
      if (items.length > 0)
        $$packLeft(new Importer(space, items).getItems())
    }

    private static function $$packLeft(items : Array) : void
    { new Packer(items[0], items.slice(1)).execute() }
  }
}

import flash.display.DisplayObject

class Item
{
  private var object : DisplayObject
  private var _width : Number

  public function Item(object : DisplayObject, width : Number)
  { this.object = object, _width = width }

  public function get width() : Number
  { return _width }

  public function get right() : Number
  { return object.x + width }

  public function packLeft(base : Item) : void
  { object.x = base.right }
}

class Importer
{
  private var space : Number
  private var items : Array

  public function Importer(space : Number, items : Array)
  { this.space = space, this.items = items }

  public function getItems() : Array
  {
    const result : Array = []

    for each (var item : Object in items)
      if (item != null)
        result.push(getItem(item))

    return result
  }

  private function getItem(item : Object) : Item
  {
    if (isCallbackFlexible(item))
      getCallback(item)(getWidth(item))

    return new Item(getDisplayObject(item), getWidth(item))
  }

  private function getDisplayObject(item : Object) : DisplayObject
  { return isImplicit(item) ? item as DisplayObject : (item as Array)[0] }

  private function getWidth(item : Object) : Number
  {
    if (isExplicit(item))
      return (item as Array)[1]
    else if (isFlexible(item))
      return flexibleWidth
    else if (isImplicit(item))
      return (item as DisplayObject).width
    else
      throw new Error("Invalid item: " + item)
  }

  private function isImplicit(item : Object) : Boolean
  { return item is DisplayObject }

  private function isIgnoredFlexible(item : Object) : Boolean
  { return item is Array && !hasSecondEntry(item) }

  private function isExplicit(item : Object) : Boolean
  { return hasSecondEntry(item) && getSecondEntry(item) is Number }

  private function isCallbackFlexible(item : Object) : Boolean
  { return hasSecondEntry(item) && getSecondEntry(item) is Function }

  private function getCallback(item : Object) : Function
  { return getSecondEntry(item) as Function }

  private function hasSecondEntry(item : Object) : Boolean
  { return item is Array && (item as Array).length == 2 }

  private function getSecondEntry(item : Object) : Object
  { return (item as Array)[1] }

  private function isFlexible(item : Object) : Boolean
  { return isCallbackFlexible(item) || isIgnoredFlexible(item) }

  private function get flexibleWidth() : Number
  { return space / flexibleCount - totalStaticWidth }

  private function get totalStaticWidth() : Number
  {
    var result : Number = 0

    for each (var item : Object in items)
      if (!isFlexible(item))
        result += getWidth(item)

    return result
  }

  private function get flexibleCount() : int
  {
    var result : int = 0

    for each (var item : Object in items)
      if (isFlexible(item))
        ++result

    return result
  }
}
