$(document).on "turbolinks:load", ->
    $(".field_with_errors").parent().addClass("has-error")
