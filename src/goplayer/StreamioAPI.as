package goplayer
{
  public class StreamioAPI
  {
    private const baseURL : String
      = "http://staging.streamio.se/api/v1/"

    private var fetcher : JSONFetcher

    public function StreamioAPI(fetcher : JSONFetcher)
    { this.fetcher = fetcher }

    public function fetchMovieMetadata
      (id : String, handler : MovieMetadataHandler) : void
    { fetch(getMovieURL(id), new StreamioMovieMetadataJSONParser(handler)) }

    private function getMovieURL(id : String) : String
    { return "movies/" + id + "/public_show.json" }

    private function fetch(url : String, handler : JSONHandler) : void
    { fetcher.fetchJSON(baseURL + url, handler) }
  }
}
