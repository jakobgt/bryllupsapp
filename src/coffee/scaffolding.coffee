scaffolding = 
  setup: () ->
    console.log('Loading scaffolding')
    numberOfSteps = $("#steps > .step").length || 0

    # sum and save the widths of each one of the fieldsets
    # set the final sum as the total width of the steps element
    stepsWidth  = 0
    widths      = []
    $('.app .page').each (i) ->
      $step       = $(this)
      widths[i]   = stepsWidth
      stepsWidth  += $step.width()

#    $('.app').width(stepsWidth);
    
    current_selected = 0
    
    show_step = (stepIndex) ->
      current_selected = stepIndex % numberOfSteps
      $('.app').stop().animate({marginLeft: '-' + widths[current_selected] + 'px'}, 500)
  show_page: (pageIndex) ->
    $('.app .page').hide()
    $($('.app .page').get(pageIndex)).show()

  bindEvents: () ->
    console.log("Binding events for anchors.")
    $('[data-show]').click () ->
      page_nr = $(this).data('show')
      scaffolding.show_page(page_nr)
      return false;


      
window.scaffolding = scaffolding