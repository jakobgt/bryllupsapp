$ ->
  # Should only load on startup, not pageshow...
  $('#pictures').live 'pageshow', () ->
    console.log("Setting up gallery")
    myPhotoSwipe = $("#Gallery a").photoSwipe {}
    return true

  onSuccess = (imageData) ->
    console.log "wuuuu"
    image = document.getElementById 'foobar'
    image.src = "data:image/jpeg;base64," + imageData
    console.log "wuuuu it went through"  

  onFail = (message) ->
    alert('Failed because: ' + message);

  takePicture = () ->
    navigator.camera.getPicture(onSuccess, onFail, {
      quality: 50
      destinationType: Camera.DestinationType.DATA_URL
    })

  $('#take_picture_button').click () ->
    console.log "Taking picture."
    takePicture()
  # {
    #   jQueryMobile: true
    # }
    #{
    #   enableMouseWheel: false,
    #   enableKeyboard: false
    # }
