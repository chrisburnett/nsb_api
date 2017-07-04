$(document).on "turbolinks:load", ->
    $("#contractor_name_autocomplete").autocomplete
        source: $("#contractor_name_autocomplete").data("source")
        select: ( event, ui ) ->
            # set job_tenant_id hidden field
            $("#assignment_contractor_id").val(ui.item.id)
            $("#contractor_name_autocomplete").val(ui.item.value)
    
