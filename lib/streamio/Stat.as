// XXX: Make this file conform to Goplayer code style.

package streamio
{
  import flash.events.*
  import flash.net.*
  
  import goplayer.StreamioAPI
  
  public class Stat
  {
    public static var trackerId:String = "global"
    
    public static function view(movieId:String) : void
    {
      update(movieId, "views")
    }
  
    public static function play(movieId:String) : void
    {
      update(movieId, "plays")
    }
    
    public static function heatmap(movieId:String, time:Number) : void
    {
      update(movieId, "heat", time)
    }
    
    private static function update(movieId:String, event:String, time:Number = NaN) : void
    {
      var params:URLVariables = new URLVariables()
      params.movie_id = movieId
      params.event = event
      params.tracker_id = trackerId
      if(!isNaN(time)) params.time = time
      
      var request:URLRequest = new URLRequest("http://"+StreamioAPI.host+"/stats")
      request.method = URLRequestMethod.POST
      request.data = params
      
      var loader:URLLoader = new URLLoader()
      loader.load(request)
    }
  }
}
