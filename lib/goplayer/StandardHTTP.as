package goplayer
{
  public class StandardHTTP implements HTTP
  {
    public function fetch
      (url : URL, handler : HTTPResponseHandler) : void
    { new HTTPFetchAttempt(url, handler).execute() }

    public function fetchJSON
      (url : URL, handler : JSONHandler) : void
    { fetch(url, new JSONAdapter(handler)) }

    public function post
      (url : URL,
       parameters : Object,
       handler : HTTPResponseHandler) : void
    { new HTTPPostAttempt(url, parameters, handler).execute() }
  }
}

import com.adobe.serialization.json.JSON

import goplayer.*

class JSONAdapter implements HTTPResponseHandler
{
  private var handler : JSONHandler

  public function JSONAdapter(handler : JSONHandler)
  { this.handler = handler }

  public function handleHTTPResponse(text : String) : void
  { handler.handleJSON(JSON.decode(text)) }
}
