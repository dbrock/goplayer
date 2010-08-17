package goplayer
{
  public class RTMPConnector
  {
    private const urls : Array = []

    private var connection : FlashNetConnection

    public function RTMPConnector
      (connection : FlashNetConnection, url : URL)
    {
      this.connection = connection

      urls.push(url)
      urls.push(url.withPort(80))
      urls.push(url.withPort(443))
    }

    public function tryNextPort() : void
    {
      if (hasMoreIdeas)
        connection.connect(getNextURL())
      else
        throw new Error
    }

    public function get hasMoreIdeas() : Boolean
    { return urls.length != 0 }

    private function getNextURL() : URL
    { return urls.shift() }
  }
}
