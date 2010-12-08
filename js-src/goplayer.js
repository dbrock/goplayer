var goplayer_swf_url = "goplayer.swf"
var goplayer_class_name = "goplayer"
var goplayer_flash_version = "9.0.0"
var goplayer_express_install_swf_url = null
var goplayer_params = { allowfullscreen: true, allowscriptaccess: true }

if (typeof swfobject === "undefined")
  alert("Please load swfobject.js before goplayer.js.")
else if (swfobject.hasFlashPlayerVersion(goplayer_flash_version))
  swfobject.addDomLoadEvent(function () {
    run()

    function run() {
      var elements = document.getElementsByTagName("video")
      
      for (var i = 0; i < elements.length; ++i)
        if (is_goplayer_element(elements[i]))
          install_player(elements[i])
    }

    function is_goplayer_element(element) {
      return element.className.split(/\s+/).
        indexOf(goplayer_class_name) !== -1
    }

    function get_data_attribute(attribute, result) {
      result[attribute.name.substring("data-".length)] = attribute.value
    }

    function get_dataset(element, result) {
      for (var i = 0; i < element.attributes.length; ++i)
        if (element.attributes[i].name.indexOf("data-") === 0)
          get_data_attribute(element.attributes[i], result)
    }

    function install_player(element) {
      var div = document.createElement("div")
      var id = "goplayer-" + Math.random()
      var width = element.offsetWidth
      var height = element.offsetHeight      
      var flashvars = {
        src: element.src,
        autoplay: element.autoplay,
        loop: element.loop
      }

      get_dataset(element, flashvars)

      div.id = id
      element.parentNode.replaceChild(div, element)

      swfobject.embedSWF
        (goplayer_swf_url,
         id,
         width, height,
         goplayer_flash_version,
         goplayer_express_install_swf_url,
         flashvars,
         goplayer_params)
    }
  })
