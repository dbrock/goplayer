package goplayer
{
  public interface HTTPResponseHandler
  {
    function handleHTTPResponse(text : String) : void
    function handleHTTPError(message : String) : void
  }
}
