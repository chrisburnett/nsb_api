$(document).on "turbolinks:load", ->
    $('ul li a').filter( () -> 
        return this.href.includes(window.location)
    ).parent().addClass('active')
