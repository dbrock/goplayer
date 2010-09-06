package goplayer
{
  public class Configuration
  {
    public var streamioMovieID : String
    public var skinURL : String
    public var autoplay : Boolean
    public var loop : Boolean

    public static function fromParameters
      (parameters : Object) : Configuration
    {
      const result : Configuration = new Configuration

      result.streamioMovieID = parameters.streamioMovieID
      result.skinURL = parameters.skinURL
      result.autoplay = parameters.autoplay == "yes"
      result.loop = parameters.loop == "yes"

      return result
    }
  }
}
