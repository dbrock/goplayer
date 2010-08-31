package goplayer
{
  public class StandardHTTPFetcher implements HTTPFetcher, JSONFetcher
  {
    public function fetch
      (url : URL, handler : HTTPResponseHandler) : void
    { new HTTPFetchAttempt(url, handler).execute() }

    public function fetchJSON
      (url : URL, handler : JSONHandler) : void
    { fetch(url, new HTTPJSONAdapter(handler)) }
  }
}
