package goplayer
{
  public class ConfigurationParser
  {
    public static const DEFAULT_API_URL : String
      = "http://staging.streamio.se/api"
    public static const DEFAULT_SKIN_URL : String = "goplayer-skin.swf"
    public static const DEFAULT_TRACKER_ID : String = "global"

    private const result : Configuration = new Configuration

    private var parameters : Object

    public function ConfigurationParser(parameters : Object)
    { this.parameters = parameters }

    public function execute() : void
    {
      result.apiURL = getString("api", DEFAULT_API_URL)
      result.skinURL = getString("skin", DEFAULT_SKIN_URL)
      result.movieID = getString("movie", null)
      result.trackerID = getString("tracker", DEFAULT_TRACKER_ID)
      result.bitratePolicy = getBitratePolicy("bitrate", BitratePolicy.BEST)
      result.enableRTMP = getBoolean("enableRtmp", true)
      result.enableAutoplay = getBoolean("enableAutoplay", false)
      result.enableLooping = getBoolean("enableLooping", false)
      result.enableChrome = getBoolean("enableChrome", true)
      result.enableUpperPanel = getBoolean("enableUpperPanel", true)
    }

    public static function parse(parameters : Object) : Configuration
    {
      const parser : ConfigurationParser
        = new ConfigurationParser(parameters)

      parser.execute()

      return parser.result
    }

    // -----------------------------------------------------

    private function getString(name : String, fallback : String) : String
    { return name in parameters ? parameters[name] : fallback }

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
          reportInvalidParameter(name, value, ["true", "false"])
          return fallback
        }

      throw new Error
    }

    private function $$getBoolean(value : String) : Boolean
    {
      if (value == "true")
        return true
      else if (value == "false")
        return false
      else
        throw new Error
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
