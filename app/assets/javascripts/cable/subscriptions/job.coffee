App.cable.subscriptions.create { channel: "JobChannel" },
    received: (data) ->
        alert(data)
