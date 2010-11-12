package goplayer
{
  public class Queue
  {
    private const items : Array = []
    
    public function enqueue(item : Object) : void
    { items.push(item) }

    public function dequeue() : *
    { return items.shift() }

    public function get empty() : Boolean
    { return items.length == 0 }
  }
}
