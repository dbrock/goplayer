package goplayer
{
  public class StreamioAPI
  {
    private const baseURL : String
      = "http://staging.streamio.se/api/v1/"

    private var fetcher : JSONFetcher

    public function StreamioAPI(fetcher : JSONFetcher)
    { this.fetcher = fetcher }

    public function fetchMovie
      (id : String, handler : MovieHandler) : void
    { fetch(getMovieURL(id), new MovieJSONHandler(handler)) }

    private function getMovieURL(id : String) : String
    { return "movies/" + id + "/public_show.json" }

    private function fetch(url : String, handler : JSONHandler) : void
    { fetcher.fetchJSON(URL.parse(baseURL + url), handler) }
  }
}

import goplayer.*

class MovieJSONHandler implements JSONHandler
{
  private var handler : MovieHandler

  public function MovieJSONHandler(handler : MovieHandler)
  { this.handler = handler }
  
  public function handleJSON(json : Object) : void
  { handler.handleMovie(new StreamioMovie(json)) }
}
