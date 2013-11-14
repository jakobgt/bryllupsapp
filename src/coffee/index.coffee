$ ->
  window.pictures_data = []
  window.pictures_data_dict = []
  window.current_start_index = 0
  window.gallery = null
  is_overlay_shown = () ->
    return $('.ps-carousel').length > 0
  is_gallery_set = () ->
    (typeof window.gallery != "undefined" && window.gallery != null)
  createGallery = () ->
    # Don't create if overlay shown
    if is_overlay_shown()
      console.log "Not create gallery"
      if is_gallery_set()
        # If we wanted to create the gallery, but we're in overlay,
        # then we make a request to delete and create.
        window.gallery.addEventHandler(window.Code.PhotoSwipe.EventTypes.onHide, (e) ->
          console.log "Returning from hiding."
          removeGalleryIfPresent()
          createGallery()
          )
    else
      console.log("Setting up gallery")
      window.gallery = $("#Gallery a").photoSwipe({
        enableKeyboard: false,
        enableMouseWheel: false
        })
      $(window).scroll(infiniteScrolling)
    
  removeGalleryIfPresent = () ->
    if is_overlay_shown()
      # If the overlay is already shown, then we don't remove the gallery.
      console.log "Gallery overlay shown already."
    else if is_gallery_set()
      console.log 'Removing gallery'
      window.Code.PhotoSwipe.unsetActivateInstance window.gallery
      window.Code.PhotoSwipe.detatch window.gallery
      window.gallery = null

  insert_pictures = (data, textStatus, jqXHR) ->
    # Window.pictures_data is the list of pictures, where the latest
    # is last.
    window.pictures_data = data
    window.pictures_data_dict = data.toDict 'id'
    window.current_start_index = data.length - 1
    showMorePictures()

  showMorePictures = () ->
    if window.current_start_index > 0
      removeGalleryIfPresent()
      end = window.current_start_index
      start = Math.max 0, end - 15
      window.current_start_index = start      
      for index in [end..start]
        picture = window.pictures_data[index]
        append_picture picture
      createGallery()
      if start == 0
        $('#picture_loading').hide()        
        $('#picture_end').show()

  Array::toDict = (key) ->
    @reduce ((dict, obj) -> dict[ obj[key] ] = obj if obj[key]?; return dict), {}

  compare_pictures = (data, textStatus, jqXHR) ->
    for picture in data
      if (typeof window.pictures_data_dict[picture.id] is "undefined")
        prepend_picture picture
        window.pictures_data.push picture
        window.pictures_data_dict[picture.id] = picture        
        
  window.get_act_code = () ->
    window.localStorage.getItem('act_code')

  window.update_pictures = (act_code) ->
    console.log('resuming')
    url = 'http://www.lineogjakob.dk/images.json?act_code=' + act_code
    $.get url, compare_pictures
    
  window.deviceReady = () ->
    console.log "Version is " + window.device.version
    if (window.device.version.substring(0,1) is '7')
      $('#pictures').css('margin-top', '20px');
      $('#pictures-toolbar').css('margin-top', '20px');
    window.load_pictures_fun = (act_code) ->
      console.log "Loading pictures."
      $('.activation_code_msg').hide()
      url = 'http://www.lineogjakob.dk/images.json?act_code=' + act_code
      $.get url, insert_pictures
      update_pictures = () ->
        window.update_pictures act_code
      document.addEventListener("resume", update_pictures , false);
      document.addEventListener("online", update_pictures , false);      
    # If act code is available, then we start downloading
    act_code = window.get_act_code()
    if act_code
      window.load_pictures_fun act_code

  prepend_picture = (picture) ->
    li_elm = generate_html_elm picture
    $(li_elm).clone().hide().prependTo($('#Gallery')).slideDown();
  append_picture = (picture) ->
    li_elm = generate_html_elm picture
    $(li_elm).clone().hide().appendTo($('#Gallery')).slideDown();

  generate_html_elm = (data) ->
    console.log "Prepending is: " + data
    small_thumb_url = "http://www.lineogjakob.dk" + data.small_thumb_url
    medium_thumb_url = "http://www.lineogjakob.dk" + data.medium_thumb_url    
    title = "Taget af " + data.guest.first_name
    if (data.guest.last_name)
      title += " " + data.guest.last_name.substring(0,1) + "."
#    title += " (" + data.id + ")"
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
    console.log "Returning the picture."
    return li_elm

  win = (response) ->
    console.log("Code = " + response.responseCode)
    console.log("Response = " + response.response)
    console.log("Sent = " + response.bytesSent)

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
    params.act_code =  window.get_act_code()
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

  remove_clicked_color = () ->
    $('.picture_buttons a').removeClass 'ui-btn-active'
  takePicture = () ->
    navigator.camera.getPicture upload_picture, onFail, 
      quality: 75
      targetWidth: 1600
      targetHeight: 1600
      destinationType: Camera.DestinationType.FILE_URI
      sourceType: navigator.camera.PictureSourceType.CAMERA
      saveToPhotoAlbum: true
      correctOrientation: true
    remove_clicked_color()
            
  uploadPictureFromLibrary = () ->
    navigator.camera.getPicture upload_picture, onFail, 
      quality: 75
      targetWidth: 1600
      targetHeight: 1600
      destinationType: Camera.DestinationType.FILE_URI
      sourceType: navigator.camera.PictureSourceType.PHOTOLIBRARY
    remove_clicked_color()
    
  $('#take_picture_button').click () ->
    console.log "Taking picture."
    takePicture()
  $('#upload_picture_button').click () ->
    console.log "Uploading picture."
    uploadPictureFromLibrary()
  # Pusher interaction
  Pusher.log = (message) ->
    if (window.console && window.console.log)
      window.console.log message

  pusher = new Pusher('542416e0dcbaf6b1fb39');
  channel = pusher.subscribe('pictures')
  channel.bind 'new_picture', (data) ->
    removeGalleryIfPresent()
    picture = $.parseJSON(data.message)
    prepend_picture picture
    window.pictures_data.push picture
    window.pictures_data_dict[picture.id] = picture
    createGallery()

  infiniteScrolling = () ->
    if $.mobile.activePage.attr("id") != "pictures"
      return
    # On IOS 7, the scrolling needs a bit of love to work, in that scrolltop should have 20 added.
    if (!($(window).scrollTop() is 0) && $(window).scrollTop() + 20 >= $(document).height() - $(window).height())
      console.log "Scrolling and showing more pictures..."
      showMorePictures()
      # CreateGallery removes my scrolling, so I need to add it again.. :-(
      # Is now done in createGallery
      # $(window).scroll(infiniteScrolling)
    
document.addEventListener('deviceready', window.deviceReady, false);

$ ->
  loadURL = (url) ->
    navigator.app.loadUrl(url, { openExternal:true });
    return false;

  $('.external_link').live 'click', ->
    url = $(this).attr("rel")
    window.open(url, '_blank');
    return false

