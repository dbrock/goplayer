function goplayer_initialize() {
  if (swfobject.hasFlashPlayerVersion(goplayer_flash_version))
    swfobject.addDomLoadEvent(function () {
      run()

      function run() {
        var elements = document.getElementsByTagName("video")

        for (var i = 0; i < elements.length; ++i)
          if (is_goplayer_element(elements[i]))
            install_player(elements[i])
      }

      function is_goplayer_element(element) {
        var classes = element.className.split(/\s+/)

        return goplayer_enable_by_default
          ? !contains(classes, goplayer_disable_class_name)
          : contains(classes, goplayer_enable_class_name)
      }

      function contains(array, element) {
        for (var i = 0; i < array.length; ++i)
          if (array[i] === element)
            return true

        return false
      }

      function get_data_attribute(attribute, result) {
        result[attribute.name.substring("data-".length)] = attribute.value
      }

      function get_dataset(element, result) {
        for (var i = 0; i < element.attributes.length; ++i)
          if (element.attributes[i].name.indexOf("data-") === 0)
            get_data_attribute(element.attributes[i], result)
      }

      function prepend_child(parent, child) {
        if (parent.hasChildNodes())
          parent.insertBefore(child, parent.firstChild)
        else
          parent.appendChild(child)
      }

      function has_attribute(element, name) {
        return element.getAttribute(name) !== null
      }

      function install_player(element) {
        var html5_supported = "videoWidth" in element
        var width = html5_supported
          ? element.offsetWidth
          : element.getAttribute("width")
        var height = html5_supported
          ? element.offsetHeight
          : element.getAttribute("height")
        var flashvars = {
          src: element.getAttribute("src"),
          autoplay: has_attribute(element, "autoplay"),
          loop: has_attribute(element, "loop"),
          "skin-show-chrome": has_attribute(element, "controls")
        }

        get_dataset(element, flashvars)

        // This can happen in non-HTML5 browsers when the <body> tag
        // is left out and the <video> tag is the first element.
        if (element.parentNode.tagName === "HEAD")
          prepend_child(document.body, element)

        element.id = element.id || "goplayer-" + Math.random()

        swfobject.embedSWF
          (goplayer_swf_url,
           element.id,
           element.getAttribute("width"),
           element.getAttribute("height"),
           goplayer_flash_version,
           goplayer_express_install_swf_url,
           flashvars,
           goplayer_params)
      }
    })
}

(function () {
  function define(name, value) {
    if (!(name in window))
      window[name] = value
  }

  define("goplayer_enable_by_default", true)
  define("goplayer_swf_url", "goplayer.swf")
  define("goplayer_swfobject_url", "swfobject.js")
  define("goplayer_load_swfobject", true)
  define("goplayer_params", {
    allowfullscreen: true,
    allowscriptaccess: true
  })

  define("goplayer_enable_class_name", "goplayer")
  define("goplayer_disable_class_name", "no-goplayer")
  define("goplayer_flash_version", "9.0.0")
  define("goplayer_express_install_swf_url", null)

  function load(src, callback) {
    var script = document.createElement("script")

    if (script.addEventListener)
      script.addEventListener("load", callback, false)
    else
      script.onreadystatechange = function () {
        if (script.readyState == "loaded")
          callback()
      }
    
    script.src = src
    document.getElementsByTagName("head")[0].appendChild(script)
  }

  if (goplayer_load_swfobject)
    load(goplayer_swfobject_url, goplayer_initialize)
  else
    goplayer_initialize()
})()
