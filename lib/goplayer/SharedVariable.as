package goplayer
{
  import flash.net.SharedObject

  public class SharedVariable
  {
    private var name : String
    private var object : SharedObject

    public function SharedVariable(objectName : String, name : String)
    {
      this.name = name

      try
        { object = SharedObject.getLocal(objectName) }
      catch (error : Error)
        { object = null }
    }

    public function get available() : Boolean
    { return object != null }

    public function get hasValue() : Boolean
    { return available && object.size > 0 }

    public function get value() : *
    { return object == null ? null : object.data[name] }

    public function set value(value : Object) : void
    {
      if (object != null)
        object.data[name] = value
    }
  }
}
