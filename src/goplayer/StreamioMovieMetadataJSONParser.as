package goplayer
{
  public class StreamioMovieMetadataJSONParser implements JSONHandler
  {
    private var handler : MovieMetadataHandler

    public function StreamioMovieMetadataJSONParser
      (handler : MovieMetadataHandler)
    { this.handler = handler }
    
    public function handleJSON(json : Object) : void
    { handler.handleMovieMetadata(new StreamioMovieMetadata(json)) }
  }
}
