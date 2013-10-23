$ ->
  # Should only load on startup, not pageshow...
  $('#pictures').live 'pageshow', () ->
    console.log("Setting up gallery")
    myPhotoSwipe = $("#Gallery a").photoSwipe {}
    return true

  win = (r) ->
    data = $.parseJSON(r.response)
    console.log "Date is: " + data
    small_thumb_url = "http://www.lineogjakob.dk" + data.small_thumb_url
    medium_thumb_url = "http://www.lineogjakob.dk" + data.medium_thumb_url    
    title = "Fra: " + data.guest.first_name
    if (data.guest.last_name)
      title += " " + data.guest.last_name.substring(0,1) + "."
    console.log "Creating elements."
    img_elm = document.createElement('img')
    img_elm.src = small_thumb_url
    img_elm.alt = title
    anchor_elm = document.createElement('a')
    anchor_elm.href = medium_thumb_url
    anchor_elm.ref = 'external'
    anchor_elm.appendChild(img_elm)
    li_elm = document.createElement('li')
    li_elm.appendChild(anchor_elm)
    $(li_elm).clone().hide().prependTo($('#Gallery')).slideDown();
    console.log "Inserting the picture."
    
    console.log("Code = " + r.responseCode)
    console.log("Response = " + r.response)
    console.log("Sent = " + r.bytesSent)

  fail = (error) ->
    console.log("upload error source " + error.source)
    console.log("upload error target " + error.target)

  upload_picture = (image_url) ->
    # Here we upload the picture to somewhere....
    console.log "uploading picture: " + image_url
    options = new FileUploadOptions()
    options.fileKey = "image[image]"
    options.fileName = image_url.substr(image_url.lastIndexOf('/')+1)
    options.mimeType = "image/jpeg"
    params = new Object();
    params.act_code = "vgyukm";
    params['image[name]'] = "From mobilephone";
    options.params = params    
    liitem = document.createElement('li')
    $('.status_bar').append(liitem)
    ft = new FileTransfer()
    ft.onprogress = (progressEvent) ->
      if (progressEvent.lengthComputable)
        perc = Math.floor(progressEvent.loaded / progressEvent.total * 100)
        liitem.innerHTML = perc + "% uploaded..."
      else
        if (liitem.innerHTML == "")
          liitem.innerHTML = "Uploading"
        else
          liitem.innerHTML += "."
    ft.upload(image_url, encodeURI("http://www.lineogjakob.dk/images.json"), ((r) ->
      $(liitem).remove()
      win(r)), ((r) ->
        $(liitem).remove()
        fail(r)), options)
    console.log "Started the upload."
    
  onFail = (message) ->
    console.log('Failed because: ' + message);

  takePicture = () ->
    navigator.camera.getPicture upload_picture, onFail, 
      quality: 50
      targetWidth: 1600
      targetHeight: 1600
      destinationType: Camera.DestinationType.FILE_URI
      sourceType: navigator.camera.PictureSourceType.CAMERA
      saveToPhotoAlbum: true
      correctOrientation: true
      
  uploadPictureFromLibrary = () ->
    navigator.camera.getPicture upload_picture, onFail, 
      quality: 50
      targetWidth: 1600
      targetHeight: 1600
      destinationType: Camera.DestinationType.FILE_URI
      sourceType: navigator.camera.PictureSourceType.PHOTOLIBRARY
    
  $('#take_picture_button').click () ->
    console.log "Taking picture."
    takePicture()
  $('#upload_picture_button').click () ->
    console.log "Uploading picture."
    uploadPictureFromLibrary()
