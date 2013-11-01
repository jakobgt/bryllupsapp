$ ->
  success_callback = () ->
    2 + 2
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
    phonenumber_input = $('#send_activation_code_phone_number')
    recognizedPhoneNumber = (data, textStatus, jgXHR) ->
      phonenumber_input.addClass('green')
      
    notRecognizedPhoneNr = () ->
      phonenumber_input.addClass('yellow')
      2 + 2
    # Setting up sending phonenumber
    current_request = null
    phonenumber_input.bind 'keyup', () ->
      phonenumber_input.removeClass('green yellow')
    $('#send_act_code').click () ->
      phonenumber_input.removeClass('green yellow')
      phonenumber = phonenumber_input.val()
      if current_request
        current_request.abort()
      if !phonenumber || phonenumber.trim() == ''
        return
      current_request = $.post('http://www.lineogjakob.dk/request_act_code.json',
        'send_activation_code[phone_number]': phonenumber, recognizedPhoneNumber).fail(notRecognizedPhoneNr)
      