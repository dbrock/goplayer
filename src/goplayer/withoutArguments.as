package goplayer
{
  public function withoutArguments(callback : Function) : Function
  {
    return function (... rest : Array) : void
    { callback() }
  }
}
