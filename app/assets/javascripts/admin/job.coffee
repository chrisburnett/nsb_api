$(document).on "turbolinks:load", ->

    $('[id^=job_tenant_attributes]').change ->
        $("#tenant_name_autocomplete").val("")
        $("#job_tenant_attributes_id").val("")
    $('[id^=job_client_attributes]').change ->
        $("#client_name_autocomplete").val("")
        $("#job_client_attributes_id").val("")
    
    $("#tenant_name_autocomplete").autocomplete
        source: $("#tenant_name_autocomplete").data("source")
        select: ( event, ui ) ->
            # set job_tenant_id hidden field
            $("#job_tenant_attributes_id").val(ui.item.id)
            $("#job_tenant_attributes_name").val(ui.item.name)
            $("#job_tenant_attributes_address").val(ui.item.address)
            $("#job_tenant_attributes_contact_number_1").val(ui.item.contact_number_1)
            $("#job_tenant_attributes_contact_number_2").val(ui.item.contact_number_2)
            $("#job_tenant_attributes_contact_number_3").val(ui.item.contact_number_3)
            $("#job_tenant_attributes_notes").val(ui.item.notes)
            $("#tenant_name_autocomplete").val(ui.item.value)
            
    $("#client_name_autocomplete").autocomplete
        source: $("#client_name_autocomplete").data("source")
        select: ( event, ui ) ->
            # set job_tenant_id hidden field
            $("#job_client_attributes_id").val(ui.item.id)
            $("#job_client_attributes_name").val(ui.item.name)
            $("#job_client_attributes_address").val(ui.item.address)
            $("#job_client_attributes_notes").val(ui.item.notes)
            $("#client_name_autocomplete").val(ui.item.value)

