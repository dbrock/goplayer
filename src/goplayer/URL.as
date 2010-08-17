package goplayer
{
  public class URL
  {
    private var scheme : String
    private var host : String
    private var port : int
    private var path : String

    public function URL
      (scheme : String, host : String, port : int, path : String)
    {
      this.scheme = scheme
      this.host = host
      this.port = port
      this.path = path
    }

    public function withPort(newPort : int) : URL
    { return new URL(scheme, host, newPort, path) }

    public function toString() : String
    {
      if (port < 0)
        return scheme + "://" + host + path
      else
        return scheme + "://" + host + ":" + port + path
    }

    public static function parse(input : String) : URL
    {
      const match : Array = input.match
        (/^(.*?):\/\/(.*?)(?::(.*?))?(\/.*?)$/)
      const port : uint = match[3] == null ? -1 : parseInt(match[3])

      return new URL(match[1], match[2], port, match[4])
    }
  }
}
