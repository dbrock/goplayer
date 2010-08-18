package goplayer
{
  import flash.display.Bitmap
  import flash.display.Loader
  import flash.events.Event

  public class ExternalImage extends Loader
  {
    public function ExternalImage()
    { contentLoaderInfo.addEventListener(Event.COMPLETE, handleComplete) }

    public function set url(value : URL) : void
    { load(value.asURLRequest) }

    private function handleComplete(event : Event) : void
    {
      try
        { Bitmap(content).smoothing = true }
      catch (error : Error)
        {}
    }
  }
}
