package goplayer
{
  import flash.display.DisplayObject
  import flash.display.DisplayObjectContainer

  public class SkinPartFinder
  {
    private var root : DisplayObject
    private var names : Array

    public function SkinPartFinder
      (root : DisplayObject, names : Array)
    {
      this.root = root
      this.names = names
    }

    private function execute() : DisplayObject
    {
      if (names.length == 0)
        return root
      else if (firstPart == null)
        throw new SkinPartMissingError([firstName])
      else
        return recurse()
    }

    private function get firstPart() : DisplayObject
    {
      return root is DisplayObjectContainer
        ? DisplayObjectContainer(root).getChildByName(firstName)
        : null
    }

    private function get firstName() : String
    { return names[0] }

    private function recurse() : DisplayObject
    {
      try 
        { return lookup(firstPart, remainingNames) }
      catch (error : SkinPartMissingError)
        { throw error.wrap(firstName) }

      throw new Error
    }

    private function get remainingNames() : Array
    { return names.slice(1) }

    public static function lookup
      (root : DisplayObject, names : Array) : *
    { return new SkinPartFinder(root, names).execute() }
  }
}
