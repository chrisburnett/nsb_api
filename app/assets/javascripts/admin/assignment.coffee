$(document).on "turbolinks:load", ->
    $("#contractor_name_autocomplete").autocomplete
        source: $("#contractor_name_autocomplete").data("source")
        select: ( event, ui ) ->
            # set job_tenant_id hidden field
            $("#assignment_contractor_id").val(ui.item.id)
            $("#contractor_name_autocomplete").val(ui.item.value)

    set_time_control_visibility = (event) ->
        if $("#assignment_am_pm_visit").val() == "Specific time"
            $("#assignment_scheduled_hour").show()
            $("#assignment_scheduled_minute").show()
        else
            $("#assignment_scheduled_hour").hide()
            $("#assignment_scheduled_minute").hide()
    set_time_control_visibility()

    $("#assignment_am_pm_visit").change set_time_control_visibility
