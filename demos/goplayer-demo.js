function block(callback) { return callback() }

var goplayer_demo_log = block(function () {
  function getTimestamp(date) {
    function pad(number, places) {
      return (number / Math.pow(10, places)).toFixed(places).substring(2)
    }

    return "<span class='time'>"
      + pad(date.getHours(), 2) + ":"
      + pad(date.getMinutes(), 2) + ":"
      + "<span class='seconds'>" + pad(date.getSeconds(), 2) + "</span>."
      + pad(date.getMilliseconds(), 3)
      + "</span>"
  }

  var lastTime

  return function (message) {
    var li = document.createElement("li")
    var span = document.createElement("span")

    var currentTime = new Date

    if (lastTime && currentTime - lastTime > 1000)
      li.className = "first"

    li.innerHTML = getTimestamp(currentTime)
    span.appendChild(document.createTextNode(message))

    var zeroWidthSpace = String.fromCharCode(0x200b) // "​"
    var valueHTML = "<span class='value'>$1</span>"
    var errorHTML = "<span class='error'>$1</span>"

    span.innerHTML = span.innerHTML
      .replace(/\/(\w)/g, "/" + zeroWidthSpace + "$1")
      .replace(/(“.*?”)/g, valueHTML)
      .replace(/(&lt;.*?&gt;)/g, valueHTML)
      .replace(/(\d+×\d+)/g, valueHTML)
      .replace(/(\d+(\.\d+)?(s|(k|M|G)?(bps|B)))/g, valueHTML)
      .replace(/(^Error: .*)/g, errorHTML)

    li.appendChild(span)

    document.getElementById("log").appendChild(li)

    var container = document.getElementById("log-container")

    container.scrollTop = container.scrollHeight

    lastTime = currentTime
  }
})

function goplayer_demo_parse_query_string(query, result) {
  var pairs = query.replace(/^\?/, "").split("&")

  for (var i = 0; i < pairs.length; ++i) {
    var pair = pairs[i]
    var match = pair.match(/^([^=]*)=(.*)$/)

    if (match == null) {
      result[pair] = null
    } else {
      var key = decodeURIComponent(match[1])
      var value = decodeURIComponent(match[2])

      result[key] = value
    }
  }
}
