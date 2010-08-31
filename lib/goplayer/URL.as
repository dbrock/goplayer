package goplayer
{
  import flash.net.URLRequest

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

    public function withScheme(newScheme : String) : URL
    { return new URL(newScheme, host, port, path) }

    public function withHost(newHost : String) : URL
    { return new URL(scheme, newHost, port, path) }

    public function get hasPort() : Boolean
    { return port >= 0 }

    public function withPort(newPort : int) : URL
    { return new URL(scheme, host, newPort, path) }

    public function get withoutPort() : URL
    { return new URL(scheme, host, -1, path) }

    public function get asURLRequest() : URLRequest
    { return new URLRequest(toString()) }

    public function toString() : String
    {
      if (hasPort)
        return scheme + "://" + host + ":" + port + path
      else
        return scheme + "://" + host + path
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
