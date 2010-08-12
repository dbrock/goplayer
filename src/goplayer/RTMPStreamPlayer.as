package goplayer
{
  import flash.display.Sprite
  import flash.events.AsyncErrorEvent
  import flash.events.NetStatusEvent
  import flash.events.TimerEvent
  import flash.media.Video
  import flash.net.NetConnection
  import flash.net.NetStream
  import flash.utils.Timer

  public class RTMPStreamPlayer extends Sprite
  {
    private const video : Video = new Video
    private const connection : NetConnection = new NetConnection
    private const timer : Timer = new Timer(0)
    private const statusbar : RTMPStreamStatusbar = new RTMPStreamStatusbar

    private var metadata : RTMPStreamMetadata

    private var stream : NetStream = null

    public function RTMPStreamPlayer(metadata : RTMPStreamMetadata)
    {
      this.metadata = metadata

      connection.addEventListener
        (NetStatusEvent.NET_STATUS, handleNetConnectionStatus)
      connection.addEventListener
        (AsyncErrorEvent.ASYNC_ERROR, handleAsyncError)
      connection.client = {}

      timer.addEventListener(TimerEvent.TIMER, handleTimerEvent)
    }

    private function handleTimerEvent(event : TimerEvent) : void
    { update() }

    public function start() : void
    {
      debug("Connecting to <" + metadata.url + ">...")
      
      try
      { connection.connect(metadata.url) }
      catch (error : Error)
      { debug("Failed to connect: " + error.message) }

      timer.start()
    }

    private function handleNetConnectionStatus
      (event : NetStatusEvent) : void
    {
      if (event.info.code == "NetConnection.Connect.Success")
        handleConnectionSuccessful()
      else
        debug("Net connection status: " + event.info.code)
    }

    private function handleConnectionSuccessful() : void
    {
      stream = new NetStream(connection)
      stream.addEventListener
        (NetStatusEvent.NET_STATUS, handleNetStreamStatus);
      stream.addEventListener
        (AsyncErrorEvent.ASYNC_ERROR, handleAsyncError);
      stream.client = {}

      video.attachNetStream(stream)

      stream.bufferTime = 5
      stream.play(metadata.name)

      video.width = metadata.dimensions.width
      video.height = metadata.dimensions.height

      addChild(video)
      addChild(statusbar)
    }

    private function handleAsyncError(event : AsyncErrorEvent) : void
    { debug("Asynchronuous error: " + event.error.message) }

    private function handleNetStreamStatus
      (event : NetStatusEvent) : void
    {
      const code : String = event.info.code

      if (code == "NetStream.Play.Reset")
        {}
      else if (code == "NetStream.Play.Start")
        debug("Data streaming started; filling buffer.")
      else if (code == "NetStream.Play.Stop")
        debug("Data streaming stopped.")
      else if (code == "NetStream.Buffer.Full")
        debug("Buffer full; starting playback.")
      else if (code == "NetStream.Buffer.Flush")
        debug("Will play buffered data (" + stream.bufferLength + "s).")
      else if (code == "NetStream.Buffer.Empty")
        debug("Buffer empty; stopping playback.")
      else
        debug("Net stream status: " + code)
    }

    private function update() : void
    {
      if (stream)
        updateStatusbar()
    }

    private function updateStatusbar() : void
    {
      statusbar.bufferLength = stream.bufferLength
      statusbar.bufferTime = stream.bufferTime
      statusbar.playheadPosition = stream.time
      statusbar.streamLength = metadata.duration

      statusbar.x = video.width - statusbar.width
      statusbar.y = video.height - statusbar.height
    }
  }
}
