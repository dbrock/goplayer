package goplayer
{
  import flash.events.Event
  import flash.net.URLLoader
  import flash.net.URLRequest
  import flash.net.URLRequestMethod
  import flash.net.URLVariables

  public class HTTPPostAttempt
  {
    private const loader : URLLoader = new URLLoader

    private var url : URL
    private var parameters : Object
    private var handler : HTTPResponseHandler

    public function HTTPPostAttempt
      (url : URL, parameters : Object, handler : HTTPResponseHandler)
    {
      this.url = url
      this.parameters = parameters
      this.handler = handler
    }

    public function execute() : void
    {
      loader.addEventListener(Event.COMPLETE, handleContentLoaded)
      loader.load(request)
    }

    private function get request() : URLRequest
    {
      const result : URLRequest = url.asURLRequest

      result.method = URLRequestMethod.POST
      result.data = data

      return result
    }

    private function get data() : URLVariables
    {
      const result : URLVariables = new URLVariables

      for (var name : String in parameters)
        result[name] = parameters[name]

      return result
    }
    
    private function handleContentLoaded(event : Event) : void
    { handler.handleHTTPResponse(loader.data) }
  }
}
