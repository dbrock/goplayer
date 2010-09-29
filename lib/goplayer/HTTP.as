package goplayer
{
  public interface HTTP
  {
    function fetch
      (url : URL, handler : HTTPResponseHandler) : void
    function fetchJSON
      (url : URL, handler : JSONHandler) : void
    function post
      (url : URL,
       parameters : Object,
       handler : HTTPResponseHandler) : void
  }
}
