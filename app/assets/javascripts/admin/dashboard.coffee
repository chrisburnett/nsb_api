$(document).on "turbolinks:load", ->
    get_dropdown_menu_for_row = (data, type, row, meta) ->
        menu_html = [ 
            "<div class='btn-group'>"
            "    <a href='"+row.edit_job_url+"' type='button' class='btn btn-xs btn-default active btn-flat'>Edit</a>"
            "    <button type='button' class='btn btn-xs btn-default active btn-flat dropdown-toggle' data-toggle='dropdown'>"
            "        <span class='caret'</class>"
            "    </button>"
            "    <ul class='dropdown-menu'>"
        ]
 
        if data.may_assign == "true"
            menu_html.push "        <li><a href='"+row.new_assignment_url+"'>New assignment</a></li>"

        if data.may_cancel == "true"
            menu_html.push "        <li><a href='"+row.edit_assignment_url+"'>Edit assignment</a></li>"

        if data.may_cancel == "true"
            menu_html.push "        <li><a href='"+row.admin_assignment_url+"' data-remote='true' data-params='assignment[status]=cancelled' data-method='put'>Cancel assignment</a></li>"

        if data.may_complete == "true"
            menu_html.push "        <li><a href='"+row.admin_job_url+"' data-remote='true' data-params='job[status]=completed' data-method='put'>Mark as completed</a></li>"

        if data.may_reopen == "true"
            menu_html.push "        <li><a href='"+row.admin_job_url+"' data-remote='true' data-params='job[status]=unassigned' data-method='put'>Reopen</a></li>"
            
        menu_html.push "        <li><a href='"+row.admin_job_url+"' data-remote='true' data-method='delete'>Delete job</a></li>"

        menu_html.concat [
            "        <li><a method='delete', href='#'>Delete</a></li>"
            "    </ul>"
            "</div>"
        ]

        return menu_html.join("\n")

    $('div.toolbar').html('''
    <span>Show jobs by status: </span>
    <div class="btn-group" data-toggle="buttons">
        <label class="btn btn-xs btn-default active">
            <input type="checkbox" checked autocomplete="off" value="unassigned">Unassigned
        </label>
        <label class="btn btn-xs btn-default active">
            <input type="checkbox" checked autocomplete="off" value="assigned">Assigned
        </label>
        <label class="btn btn-xs btn-default active">
            <input type="checkbox" checked autocomplete="off" value="review">Review
        </label>
        <label class="btn btn-xs btn-default active">
            <input type="checkbox" checked autocomplete="off" value="completed">Completed
        </label>
        <label class="btn btn-xs btn-default">
            <input type="checkbox"  autocomplete="off" value="invoiced">Invoiced
        </label>
    </div>
    ''')
    $('div.toolbar label input').on 'change', (event) -> jobs_table.api().ajax.reload()
    $('#invoice-button').on 'click', (event) -> invoice_modal()
    $('#invoice-modal-submit-button').on 'click', (event) -> submit_invoice_modal()
    jobs_table = $('#jobs-table').dataTable
        processing: true
        serverSide: true
        ajax: {
            url: $('#jobs-table').data('source')
            data: (d) ->
                d.statuses = jQuery.makeArray($('input:checkbox:checked')).map( (elem) -> elem.value )
                return undefined
        }
        pagingType: 'full_numbers'
        columnDefs: [ {
            orderable: false,
            className: 'select-checkbox',
            targets: 0
        } ],
        select: {
            style:    'multi',
            selector: 'td:first-child'
        },
        order: [[ 1, 'asc' ]]
        columns: [
          null,
          {data: 'jobnumber'}
          {data: 'tenant'}
          {data: 'contractor'}
          {data: 'client'}
          {data: 'status', searchable: true, render: (data, type, full, meta) ->
            data = "unassigned" if !data?
            status_map = {
                unassigned: "default",
                pending: "info",
                accepted: "primary",
                rejected: "danger",
                cancelled: "danger",
                review: "warning",
                completed: "success",
                invoiced: "success"
            }
            return '<span class="label label-'+status_map[data.slice(data.lastIndexOf(' ')+1)]+'">'+data+'</span>'
          }
          { data: null, sortable: false, render: get_dropdown_menu_for_row, createdCell: (td, cellData, rowData, row, col) ->
              $(td).on "ajax:success", (e, data, kjstatus, xhr) ->
                  jobs_table.api().ajax.reload()
          }
        ]

    # listener for selection events tp enable/disable invoicing button
    $('#jobs-table').on 'select.dt deselect.dt', () ->
        if jobs_table.DataTable().rows({selected: true}).data().length == 0
            $('#invoice-button').addClass('disabled')
        else
            $('#invoice-button').removeClass('disabled')

        
    cancel_assignment = (url) ->
        $.post url,
            status: 'cancelled'
            (data) -> alert("success")

    invoice_modal = () ->
        selectedRows = jobs_table.DataTable().rows({selected: true})
        invoiceTable = $("#invoice-modal").find("tbody")
        invoiceTable.empty()
        for row in selectedRows.data()
            do (row) ->
                newRow = $("<tr></tr>")
                newRow.append("<td>"+row.jobnumber+"</td>")
                if row.status == "completed"
                    newRow.append("<td><input class='form-control' type='text'></td>")
                else if row.status == "invoiced"
                    newRow.append("<td>Job is already invoiced.</td>")
                else
                    newRow.append("<td>Job is not completed.</td>")
                invoiceTable.append(newRow)
        $("#invoice-modal").modal('show')

    submit_invoice_modal = () ->
        jobs = []
        invoiceRows = $("#invoice-modal").find("tbody").find("tr")
        invoiceRows.each (idx) ->
            cells = $(this).find("td")
            if cells[1].firstChild.tagName == "INPUT"
                jobs.push { jobnumber: cells[0].innerText, invoicenumber: cells[1].firstChild.value }

        $.ajax({
            type: "PUT",
            url: $('#invoice-modal').data('url')
            contentType: 'application/json'
            data: JSON.stringify({jobs: jobs})
        }).always((data) ->
            jobs_table.api().ajax.reload()
            $('#invoice-modal').modal('hide')
        )
