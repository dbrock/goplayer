package goplayer
{
  public class StandardHTTP implements HTTP
  {
    public function fetch
      (url : URL, handler : HTTPResponseHandler) : void
    { new HTTPFetchAttempt(url, handler).execute() }

    public function post
      (url : URL,
       parameters : Object,
       handler : HTTPResponseHandler) : void
    { new HTTPPostAttempt(url, parameters, handler).execute() }
  }
}
