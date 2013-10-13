$ ->
  # Should only load on startup, not pageshow...
  $('#pictures').live 'pageshow', () ->
    console.log("Setting up gallery")
    myPhotoSwipe = $("#Gallery a").photoSwipe {}
    return true
    # {
    #   jQueryMobile: true
    # }
    #{
    #   enableMouseWheel: false,
    #   enableKeyboard: false
    # }
