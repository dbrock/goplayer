package goplayer
{
  import org.asspec.specification.AbstractSpecification

  public class PlayerSpecification
    extends AbstractSpecification
    implements FlashNetConnection
  {
    private var connectionAttempted : Boolean = false
    private var requestedURL : URL

    override protected function execute() : void
    {
      const movie : FakeMovie
        = new FakeMovie(URL.parse("rtmp://foo/bar"))
      const player : Player
        = new Player(movie, this)
      
      when("started", function () : void {
        player.start()
        it_should_connect_to("rtmp://foo/bar")

        when("the connection fails", function () : void {
          player.handleConnectionFailed()
          it_should_connect_to("rtmp://foo:80/bar")

          when("the connection fails again", function () : void {
            player.handleConnectionFailed()
            it_should_connect_to("rtmp://foo:443/bar")

            when("the connection fails again", function () : void {
              connectionAttempted = false
              player.handleConnectionFailed()

              it("should not try to connect again", function () : void {
                specify(connectionAttempted).should.not.hold })
            })
          })
        })
      })
    }

    private function it_should_connect_to(url : String) : void
    {
      it("should connect to " + url, function () : void {
        specify(requestedURL).should.look_like(url) })
    }

    public function set listener(value : FlashNetConnectionListener) : void
    {}

    public function connect(url : URL) : void
    { connectionAttempted = true, requestedURL = url }

    public function getNetStream() : FlashNetStream
    { return null }
  }
}

import goplayer.*

class FakeMovie implements Movie
{
  private var _url : URL

  public function FakeMovie(url : URL)
  { _url = url }

  public function get title() : String { return null }
  public function get duration() : Duration { return null }
  public function get aspectRatio() : Number { return NaN }
  public function get imageURL() : URL { return null }

  public function get rtmpURL() : URL { return _url }
  public function get rtmpStreams() : Array { return null }
}
