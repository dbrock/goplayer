package goplayer
{
  public class FlashContentLoader
  {
    public function load
      (url : String, listener : FlashContentLoaderListener) : void
    { new FlashContentLoadAttempt(url, listener).execute() }
  }
}
