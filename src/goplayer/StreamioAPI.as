package goplayer
{
  public class StreamioAPI implements MovieEventReporter
  {
    private static const VERSION : String = "/v1"

    private var baseURL : String
    private var http : HTTP
    private var trackerID : String

    public function StreamioAPI
      (baseURL : String, http : HTTP, trackerID : String)
    {
      this.baseURL = baseURL
      this.http = http
      this.trackerID = trackerID
    }

    // -----------------------------------------------------

    public function fetchMovie
      (id : String, handler : MovieHandler) : void
    { fetch(getJSONMoviePath(id), new MovieJSONHandler(handler, this)) }

    public function getShareMovieURL(id : String) : URL
    { return getURL(getMoviePath(id)) }
    
    public function reportMovieViewed(movieID : String) : void
    { reportMovieEvent(movieID, "views", {}) }
  
    public function reportMoviePlayed(movieID : String) : void
    { reportMovieEvent(movieID, "plays", {}) }
    
    public function reportMovieHeatmapData
      (movieID : String, time : Number) : void
    { reportMovieEvent(movieID, "heat", { time: time }) }

    private function reportMovieEvent
      (movieID : String, event : String, parameters : Object) : void
    {
      if (trackerID != null && trackerID != "")
        post(statsPath, getStatsParameters(movieID, event, parameters))
    }

    private function getStatsParameters
      (movieID : String, event : String, parameters : Object) : Object
    {
      const result : Object = new Object

      result.tracker_id = trackerID
      result.video_id = movieID
      result.event = event

      for (var name : String in parameters)
        result[name] = parameters[name]

      return result
    }

    // -----------------------------------------------------

    private function getMoviePath(id : String) : String
    { return "/videos/" + id + "/public_show" }

    private function getJSONMoviePath(id : String) : String
    { return getMoviePath(id) + ".json" }

    private function get statsPath() : String
    { return "/stats" }

    // -----------------------------------------------------

    private function fetch(path : String, handler : JSONHandler) : void
    { http.fetchJSON(getURL(path), handler) }

    private function post(path : String, parameters : Object) : void
    { http.post(getURL(path), parameters, new NullHTTPHandler) }

    private function getURL(path : String) : URL
    { return URL.parse(baseURL + VERSION + path) }
  }
}

import goplayer.*

class MovieJSONHandler implements JSONHandler
{
  private var handler : MovieHandler
  private var api : StreamioAPI

  public function MovieJSONHandler
    (handler : MovieHandler, api : StreamioAPI)
  { this.handler = handler, this.api = api }
  
  public function handleJSON(json : Object) : void
  { handler.handleMovie(new StreamioMovie(json, api)) }
}

class NullHTTPHandler implements HTTPResponseHandler
{ public function handleHTTPResponse(text : String) : void {} }
