package goplayer
{
  import org.asspec.SizedTest
  import org.asspec.basic.AbstractSuite

  public class MainSuite extends AbstractSuite implements SizedTest
  {
    public function get size() : uint { return 10 }

    override protected function populate() : void
    {
      add(DimensionsSpecification)
      add(URLSpecification)
      add(PlayerSpecification)
    }
  }
}
