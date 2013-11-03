$ ->
  # This function checks that the person has entered an attendance
  # number, if not the enter attendance number page is shown.
  checkLoginInfo = (success) ->
    act_code = window.get_act_code()
    if !act_code
      window.showActCodeForm(success)
  $(document).on 'pageinit', '#pictures', () ->
    # We check that 
    checkLoginInfo window.load_pictures_fun
