package goplayer
{
  import com.adobe.serialization.json.JSON

  public class HTTPJSONAdapter implements HTTPResponseHandler
  {
    private var handler : JSONHandler

    public function HTTPJSONAdapter(handler : JSONHandler)
    { this.handler = handler }

    public function handleHTTPResponse(text : String) : void
    { handler.handleJSON(JSON.decode(text)) }
  }
}
