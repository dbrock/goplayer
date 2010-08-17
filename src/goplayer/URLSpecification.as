package goplayer
{
  import org.asspec.specification.AbstractSpecification

  public class URLSpecification extends AbstractSpecification
  {
    override protected function execute() : void
    {
      it("should stringify correctly", function () : void {
        specify(new URL("rtmp", "foo", 1234, "/bar"))
          .should.look_like("rtmp://foo:1234/bar")
      })

      it("should parse full URL correctly", function () : void {
        specify(URL.parse("rtmp://foo:1234/bar"))
          .should.look_like("rtmp://foo:1234/bar")
      })

      it("should parse portless URL correctly", function () : void {
        specify(URL.parse("rtmp://foo/bar"))
          .should.look_like("rtmp://foo/bar")
      })

      it("should replace port correctly", function () : void {
        specify(URL.parse("rtmp://foo:1234/bar").withPort(5678))
          .should.look_like("rtmp://foo:5678/bar")
      })
    }
  }
}
