package goplayer
{
  public class StandardHTTPFetcher implements HTTPFetcher, JSONFetcher
  {
    public function fetch
      (url : String, handler : HTTPResponseHandler) : void
    { new HTTPFetchAttempt(url, handler).execute() }

    public function fetchJSON
      (url : String, handler : JSONHandler) : void
    { fetch(url, new HTTPJSONAdapter(handler)) }
  }
}
