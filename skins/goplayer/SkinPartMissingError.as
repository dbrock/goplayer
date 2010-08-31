package goplayer
{
  public class SkinPartMissingError extends Error
  {
    public var names : Array

    public function SkinPartMissingError(names : Array)
    { this.names = names }

    public function wrap(name : String) : SkinPartMissingError
    { return new SkinPartMissingError([name].concat(names)) }
  }
}
