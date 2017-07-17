$(document).on "turbolinks:load", ->
    App.cable.subscriptions.create "JobChannel",
        received: (data) ->
            $('#jobs-table').DataTable().ajax.reload()
