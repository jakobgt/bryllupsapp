$ ->
  # Should only load on startup, not pageshow...
  $('#pictures').live 'pageshow', () ->
    console.log("Setting up gallery")
    myPhotoSwipe = $("#Gallery a").photoSwipe {}
    return true

  fileURI = "res/screen/windows-phone/screen-portrait.jpg"
  win = (r) ->
    console.log("Code = " + r.responseCode)
    console.log("Response = " + r.response)
    console.log("Sent = " + r.bytesSent)

  fail = (error) ->
    console.log("upload error source " + error.source)
    console.log("upload error target " + error.target)

  onSuccess = (image_url) ->
    # Here we upload the picture to somewhere....
    console.log "uploading pictures"
    console.log image_url

    options = new FileUploadOptions()
    console.log "Setting fileKey"    
    options.fileKey = "image[image]"
    console.log "fileKey was set."    
    options.fileName = image_url.substr(image_url.lastIndexOf('/')+1)
    options.mimeType = "image/jpeg"
    options.chunkedMode = false;
    
    console.log "fileName was set!, "
    console.log options.fileName
    params = new Object();
    params.act_code = "vgyukm";
    params['image[name]'] = "From mobilephone";
    console.log "Setting params"
    options.params = params    
    console.log options
    ft = new FileTransfer()
    ft.upload(image_url, encodeURI("http://www.lineogjakob.dk/images.json"), win, fail, options);
    console.log "wuuuu it went through"
    
  onFail = (message) ->
    console.log('Failed because: ' + message);

  takePicture = () ->
    navigator.camera.getPicture(onSuccess, onFail, {
      quality: 50
      destinationType: Camera.DestinationType.FILE_URI
      sourceType: navigator.camera.PictureSourceType.PHOTOLIBRARY
    })
    
  $('#take_picture_button').click () ->
    console.log "Taking picture."
    takePicture()
