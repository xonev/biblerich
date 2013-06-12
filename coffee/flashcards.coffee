$ ->
  $('.card').click ->
    $(this).flip
      content: $('.answer')
