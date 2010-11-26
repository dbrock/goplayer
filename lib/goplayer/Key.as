package goplayer
{
  import flash.events.KeyboardEvent

  public class Key
  {
    private var event : KeyboardEvent

    public function Key(event : KeyboardEvent)
    { this.event = event }

    public function get code() : uint
    { return event.keyCode }

    public function get character() : uint
    { return event.charCode }
  }
}
