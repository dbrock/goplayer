package goplayer
{
  import flash.system.System
  
  public class ShareEmbed
  {
    private var movie : Movie
    private var dimensions : Dimensions

    public function ShareEmbed(movie : Movie, dimensions : Dimensions)
    { this.movie = movie, this.dimensions = dimensions }
    
    public function openTwitter() : void
    { openURL(twitterURL) }

    public function openFacebook() : void
    { openURL(facebookURL) }

    private function openURL(url : String) : void
    { callJavascript("window.open", url, "share") }

    private function get twitterURL() : String
    {
      return "http://twitter.com/share?"
        + "url=" + encodeURIComponent(shareURL) + "&"
        + "text=" + encodeURIComponent(twitterText)
    }

    private function get twitterText() : String
    { return "Check out this video: " + movie.title }

    private function get facebookURL() : String
    {
      return "http://www.facebook.com/sharer.php?"
        + "u=" + encodeURIComponent(shareURL) + "&"
        + "t=" + encodeURIComponent(movie.title)
    }

    public function get shareURL() : String
    { return movie.shareURL.toString() }

    public function copyShareURL() : void
    { copy(shareURL) }

    public function copyEmbedCode() : void
    { copy(embedCode) }

    private function copy(text : String) : void
    { System.setClipboard(text) }

    public function get embedCode() : String
    {
      const attributes : Array =
        ['width="' + dimensions.width + '"',
         'height="' + dimensions.height + '"',
         'src="' + shareURL + '"']
        
      return "<iframe " + attributes.join(" ") + "></iframe>"
    }
  }
}
