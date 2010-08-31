package goplayer
{
  import org.asspec.specification.AbstractSpecification

  public class DimensionsSpecification extends AbstractSpecification
  {
    override protected function execute() : void
    {
      it("should stringify correctly", function () : void {
        specify(new Dimensions(1, 2)).should.look_like("1×2") })

      it("should calculate inner dimensions correctly", function () : void {
        specify(new Dimensions(1, 1).getInnerDimensions(1))
          .should.look_like("1×1")
        specify(new Dimensions(1, 1).getInnerDimensions(2))
          .should.look_like("1×0.5")
        specify(new Dimensions(1, 1).getInnerDimensions(.5))
          .should.look_like("0.5×1")
        specify(new Dimensions(2, 1).getInnerDimensions(2))
          .should.look_like("2×1")
        specify(new Dimensions(1, 2).getInnerDimensions(.5))
          .should.look_like("1×2")
      })
    }
  }
}
