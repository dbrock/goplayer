package goplayer
{
  public function clamp
    (value : Number, min : Number, max : Number) : Number
  { return Math.max(min, Math.min(value, max)) }
}
