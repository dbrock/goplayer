package goplayer
{
  public class Configuration
  {
    public var movieID : String
    public var skinURL : String
    public var autoplay : Boolean
    public var loop : Boolean
    public var bitratePolicy : BitratePolicy

    public static function fromParameters
      (parameters : Object) : Configuration
    {
      const result : Configuration = new Configuration

      result.movieID = parameters.movieId
      result.skinURL = parameters.skinUrl
      result.autoplay = parameters.autoplay == "yes"
      result.loop = parameters.loop == "yes"

      if ("bitrate" in parameters)
        result.bitratePolicy = BitratePolicy.parse(parameters.bitrate)

      if (result.bitratePolicy == null)
        result.bitratePolicy = BitratePolicy.BEST

      return result
    }
  }
}
