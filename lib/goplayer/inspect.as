package goplayer
{
  import com.adobe.serialization.json.JSON

  public function inspect(object : Object) : String
  { return JSON.encode(object) }
}
