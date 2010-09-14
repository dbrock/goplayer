package goplayer
{
  public class ConfigurationParser
  {
    private const result : Configuration = new Configuration

    private var parameters : Object

    public function ConfigurationParser(parameters : Object)
    { this.parameters = parameters }

    public function execute() : void
    {
      result.host = parameters.host || "staging.streamio.se"
      result.movieID = parameters.movieId
      result.skinURL = parameters.skinUrl || "http://" + result.host + "/swfs/goplayer-black-skin.swf"
      result.autoplay = getBoolean("autoplay", false)
      result.loop = getBoolean("loop", false)
      result.chrome = getBoolean("chrome", true)
      result.bitratePolicy = getBitratePolicy("bitrate", BitratePolicy.BEST)
    }

    public static function parse(parameters : Object) : Configuration
    {
      const parser : ConfigurationParser
        = new ConfigurationParser(parameters)

      parser.execute()

      return parser.result
    }

    // -----------------------------------------------------

    private function getBitratePolicy
      (name : String, fallback : BitratePolicy) : BitratePolicy
    {
      if (name in parameters)
        return $getBitratePolicy(name, parameters[name], fallback)
      else
        return fallback
    }

    private function $getBitratePolicy
      (name : String, value : String,
       fallback : BitratePolicy) : BitratePolicy
    {
      try
        { return $$getBitratePolicy(value) }
      catch (error : Error)
        {
          reportInvalidParameter(name, value, BITRATE_POLICY_VALUES)
          return fallback
        }

      throw new Error
    }

    private const BITRATE_POLICY_VALUES : Array =
      ["<number>kbps", "min", "max", "best"]

    private function $$getBitratePolicy(value : String) : BitratePolicy
    {
      if (value == "max")
        return BitratePolicy.MAX
      else if (value == "min")
        return BitratePolicy.MIN
      else if (value == "best")
        return BitratePolicy.BEST
      else if (Bitrate.parse(value))
        return BitratePolicy.specific(Bitrate.parse(value))
      else
        throw new Error
    }

    // -----------------------------------------------------

    private function getBoolean
      (name : String, fallback : Boolean) : Boolean
    {
      if (name in parameters)
        return $getBoolean(name, parameters[name], fallback)
      else
        return fallback
    }

    private function $getBoolean
      (name : String, value : String, fallback : Boolean) : Boolean
    {
      try
        { return $$getBoolean(value) }
      catch (error : Error)
        {
          reportInvalidParameter(name, value, ["on", "off"])
          return fallback
        }

      throw new Error
    }

    private function $$getBoolean(value : String) : Boolean
    {
      if (value == "on")
        return true
      else if (value == "off")
        return false
      else
        throw new Error
    }

    // -----------------------------------------------------

    private function reportInvalidParameter
      (name : String, value : String, validValues : Array) : void
    {
      debug("Error: Invalid parameter: “" + name + "=" + value + "”; " +
            getInvalidParameterHint(validValues) + ".")
    }

    private function getInvalidParameterHint(values : Array) : String
    { return $getInvalidParameterHint(getQuotedValues(values)) }

    private function $getInvalidParameterHint(values : Array) : String
    {
      return "please use " +
        "either " + values.slice(0, -1).join(", ") + " " +
        "or " + values[values.length - 1]
    }

    private function getQuotedValues(values : Array) : Array
    {
      var result : Array = []

      for each (var value : String in values)
        result.push("“" + value + "”")

      return result
    }
  }
}
