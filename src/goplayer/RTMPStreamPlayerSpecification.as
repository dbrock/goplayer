package goplayer
{
  import org.asspec.specification.AbstractSpecification

  public class RTMPStreamPlayerSpecification
    extends AbstractSpecification
    implements FlashNetConnection
  {
    private var connectionAttempted : Boolean = false
    private var requestedURL : URL

    override protected function execute() : void
    {
      const metadata : FakeRTMPStreamMetadata
        = new FakeRTMPStreamMetadata(URL.parse("rtmp://foo/bar"))
      const player : RTMPStreamPlayer
        = new RTMPStreamPlayer(metadata, this)
      
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

class FakeRTMPStreamMetadata implements RTMPStreamMetadata
{
  private var _url : URL

  public function FakeRTMPStreamMetadata(url : URL)
  { _url = url }

  public function get url() : URL { return _url }
  public function get name() : String { return null }
  public function get dimensions() : Dimensions { return null }
  public function get duration() : Duration { return null }
}
