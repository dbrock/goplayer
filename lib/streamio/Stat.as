package streamio
{
  import flash.events.*
  import flash.net.*
  
  import goplayer.StreamioAPI
  
  public class Stat
  {
    public static var trackerId:String = "global"
    
    public static function view(movieId:String)
    {
      update(movieId, "views")
    }
  
    public static function play(movieId:String)
    {
      update(movieId, "plays")
    }
    
    public static function heatmap(movieId:String, time:Number)
    {
      update(movieId, "heat", time)
    }
    
    private static function update(movieId:String, event:String, time = null)
    {
      var params:URLVariables = new URLVariables()
      params.movie_id = movieId
      params.event = event
      params.tracker_id = trackerId
      if(time) params.time = time
      
      var request:URLRequest = new URLRequest("http://"+StreamioAPI.host+"/stats")
      request.method = URLRequestMethod.POST
      request.data = params
      
      var loader:URLLoader = new URLLoader()
      loader.load(request)
    }
  }
}
