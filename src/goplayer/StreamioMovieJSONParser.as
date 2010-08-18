package goplayer
{
  public class StreamioMovieJSONParser implements JSONHandler
  {
    private var handler : MovieHandler

    public function StreamioMovieJSONParser(handler : MovieHandler)
    { this.handler = handler }
    
    public function handleJSON(json : Object) : void
    { handler.handleMovie(new StreamioMovie(json)) }
  }
}
