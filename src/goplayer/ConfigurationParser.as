package goplayer
{
  public class ConfigurationParser
  {
    public static const DEFAULT_STREAMIO_API_URL : String
      = "http://staging.streamio.com/api"
    public static const DEFAULT_SKIN_URL : String = "goplayer-skin.swf"
    public static const DEFAULT_TRACKER_ID : String = "global"

    public static const VALID_PARAMETERS : Array = [
      "streamio:api", "tracker", "skin", "video", "bitrate",
      "enablertmp", "autoplay", "loop",
      "skin:showchrome", "skin:showtitle" ]

    private const result : Configuration = new Configuration

    private var parameters : Object
    private var originalParameterNames : Object

    public function ConfigurationParser
      (parameters : Object, originalParameterNames : Object)
    {
      this.parameters = parameters
      this.originalParameterNames = originalParameterNames
    }

    public function execute() : void
    {
      result.apiURL = getString("streamio:api", DEFAULT_STREAMIO_API_URL)
      result.trackerID = getString("tracker", DEFAULT_TRACKER_ID)
      result.skinURL = getString("skin", DEFAULT_SKIN_URL)
      result.movieID = getString("video", null)
      result.bitratePolicy = getBitratePolicy("bitrate", BitratePolicy.BEST)
      result.enableRTMP = getBoolean("enablertmp", true)
      result.enableAutoplay = getBoolean("autoplay", false)
      result.enableLooping = getBoolean("loop", false)
      result.enableChrome = getBoolean("skin:showchrome", true)
      result.enableTitle = getBoolean("skin:showtitle", true)
    }

    public static function parse(parameters : Object) : Configuration
    {
      const normalizedParameters : Object = {}
      const originalParameterNames : Object = {}

      for (var name : String in parameters)
        if (VALID_PARAMETERS.indexOf(normalize(name)) == -1)
          reportUnknownParameter(name)
        else
          normalizedParameters[normalize(name)] = parameters[name],
            originalParameterNames[normalize(name)] = name

      const parser : ConfigurationParser = new ConfigurationParser
        (normalizedParameters, originalParameterNames)

      parser.execute()

      return parser.result
    }

    private static function normalize(name : String) : String
    { return name.toLowerCase().replace(/[^a-z:]/g, "") }

    private static function reportUnknownParameter(name : String) : void
    { debug("Error: Unknown parameter: " + name) }

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
      debug("Error: Invalid parameter: " +
            "“" + originalParameterNames[name] + "=" + value + "”; " +
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
