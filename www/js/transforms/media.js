
var player;
var mediaURL
var ogv = require('ogv')

function showVideo(target) {
  stopVideo()
  player = new ogv.OGVPlayer()
  player.src = mediaURL + '?originalSrc=' + target.alt
  player.poster = target.src
  player.width  = target.width
  player.height = target.height
  var container = target.parentElement
  container.replaceChild(player, target)
  player.play()
}

function stopVideo() {
  if (player) player.pause()
}

function sendMediaWithTarget(target) {
  showVideo(target)
}

function handleMediaClickEvent(event){
  const target = event.target
  if(!target) {
    return
  }
  const file = target.getAttribute('alt')
  if(!file) {
    return
  }
  sendMediaWithTarget(target)
}

function install(doc,_mediaURL,_filesURL) {
  mediaURL = _mediaURL
  OGVLoader.base = _filesURL
  Array.from(document.querySelectorAll('img[alt^="File:"],[alt$=".ogv"]')).forEach(function(element){
    element.addEventListener('click',function(event){
      event.preventDefault()
      handleMediaClickEvent(event)
    },false)
  })
}

exports.install = install
