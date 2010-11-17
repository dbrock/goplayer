package goplayer
{
  import org.asspec.specification.AbstractSpecification

  import flash.display.Sprite

  public class PackerSpecification extends AbstractSpecification
  {
    override protected function execute() : void
    {
      const a : Sprite = getSquare(1)
      const b : Sprite = getSquare(1)

      it("should pack using internal widths", function () : void {
        Packer.packLeft(NaN, a, b)
        specify(b.x).should.equal(1)
      })

      it("should honor explicit widths", function () : void {
        Packer.packLeft(NaN, [a, 2], b)
        specify(b.x).should.equal(2)
      })

      it("should give free space to flexible element", function () : void {
        Packer.packLeft(5, [a], b)
        specify(b.x).should.equal(4)
      })
    }

    private static function getSquare(side : Number) : Sprite
    {
      const result : Sprite = new Sprite

      result.graphics.beginFill(0)
      result.graphics.drawRect(0, 0, side, side)
      result.graphics.endFill()

      return result
    }
  }
}
