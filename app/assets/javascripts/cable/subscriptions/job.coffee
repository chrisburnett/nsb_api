$(document).on "turbolinks:load", ->
    App.cable.subscriptions.create "JobChannel",
        received: (data) ->
            alert(data)
