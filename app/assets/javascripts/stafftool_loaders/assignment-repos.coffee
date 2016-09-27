ready = ->
  $('.js-assignment-repo-list').ready ->
    $this = $(this)
    $.get $this.data('load'),
      (data) ->
        this.html(data)
        $('js-content-loading-indicator').hide()

$(document).ready(ready)
