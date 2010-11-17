package goplayer
{
  import org.asspec.basic.AbstractSuite

  public class LibrarySuite extends AbstractSuite
  {
    override protected function populate() : void
    {
      add(DimensionsSpecification)
      add(PackerSpecification)
      add(URLSpecification)
    }
  }
}
