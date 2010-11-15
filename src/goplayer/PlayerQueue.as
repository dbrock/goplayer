package goplayer
{
  public class PlayerQueue
  {
    private const queue : Queue = new Queue

    public var listener : PlayerQueueListener

    public function play() : void
    { enqueue(PlayerCommand.PLAY) }

    public function pause() : void
    { enqueue(PlayerCommand.PAUSE) }

    public function stop() : void
    { enqueue(PlayerCommand.STOP) }

    private function enqueue(command : PlayerCommand) : void
    {
      queue.enqueue(command)

      if (listener != null)
        listener.handleCommandEnqueued()
    }

    public function dequeue() : PlayerCommand
    { return queue.dequeue() }

    public function get empty() : Boolean
    { return queue.empty }
  }
}
