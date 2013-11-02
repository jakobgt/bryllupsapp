$ ->
  # Calling by default the one set by index.coffee
  success_callback = (act_code) ->
    if window.load_pictures_fun
      window.load_pictures_fun(act_code)
      
  window.showActCodeForm = (success) ->
    $.mobile.changePage $("#act_code_form")
    success_callback = success

  act_code_elm = $('#invitation_act_code')
  use_code_button = $('#use_this_code_button')
  use_code_ui_button = null
  
  use_code_button.click () ->
    success_callback(window.localStorage.getItem 'act_code')
    $.mobile.changePage $('#pictures')
  
  validateActCode = (data, textStatus, jqXHR) ->
    act_code_elm.addClass('green')
    window.localStorage.setItem 'act_code', act_code_elm.val()
    use_code_ui_button.show()
      
  removeGreen = () ->
    act_code_elm.removeClass('green')
    use_code_ui_button.hide()    

  current_request = null
  $(document).on 'pageinit', '#act_code_form', () ->
    # Setting up retrieving activation code
    use_code_ui_button = use_code_button.closest('.ui-btn')
    use_code_ui_button.hide()    
    act_code_elm.bind 'keyup', (e) ->
      if current_request
        current_request.abort()
      use_code_ui_button.hide()            
      value = $(this).val()
      if !value || value.trim() == ''
        return
      current_request = $.get('http://www.lineogjakob.dk/invitations/find_by_act_code.json',
        'invitation[act_code]': value, validateActCode).fail(removeGreen)

  #################################
  # Setting up phonenumber request
  $(document).on 'pageinit', '#act_code_form', () ->
    # Elements used.
    phonenumber_input = $('#send_activation_code_phone_number')
    number_not_found_msg = $('.number_not_found')
    number_found_msg = $('.number_found_sms_sent')
    
    recognizedPhoneNumber = (data, textStatus, jgXHR) ->
      phonenumber_input.addClass('green')
      number_found_msg.show()
      
    notRecognizedPhoneNr = () ->
      phonenumber_input.addClass('yellow')
      number_not_found_msg.show()      
      2 + 2
      
    # Setting up sending phonenumber
    current_request = null
    phonenumber_input.bind 'keyup', () ->
      phonenumber_input.removeClass('green yellow')
    $('#send_act_code').click () ->
      phonenumber_input.removeClass('green yellow')
      number_not_found_msg.hide()
      number_found_msg.hide()
      phonenumber = phonenumber_input.val()
      if current_request
        current_request.abort()
      if !phonenumber || phonenumber.trim() == ''
        return
      current_request = $.post('http://www.lineogjakob.dk/request_act_code.json',
        'send_activation_code[phone_number]': phonenumber, recognizedPhoneNumber).fail(notRecognizedPhoneNr)
      