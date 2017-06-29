$ ->
    $("#tenant_name_autocomplete").autocomplete
        source: $("#tenant_name_autocomplete").data("source")
        select: ( event, ui ) ->
            # set job_tenant_id hidden field
            $("#job_tenant_id").val(ui.item.id)
            $("#tenent_name_autocomplete").val(ui.item.value)
            
    $("#client_name_autocomplete").autocomplete
        source: $("#client_name_autocomplete").data("source")
        select: ( event, ui ) ->
            # set job_tenant_id hidden field
            $("#client_tenant_id").val(ui.item.id)
            $("#client_name_autocomplete").val(ui.item.value)
    
