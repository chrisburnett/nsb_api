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
        <label class="btn btn-xs btn-default active">
            <input type="checkbox" checked autocomplete="off" value="invoiced">Invoiced
        </label>
    </div>
    ''')
    $('div.toolbar label input').on 'change', (event) -> jobs_table.api().ajax.reload()
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
        columns: [
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
                completed: "success"
            }
            return '<span class="label label-'+status_map[data.slice(data.lastIndexOf(' ')+1)]+'">'+data+'</span>'
          }
          { data: null, sortable: false, render: get_dropdown_menu_for_row, createdCell: (td, cellData, rowData, row, col) ->
              $(td).on "ajax:success", (e, data, status, xhr) ->
                  jobs_table.api().ajax.reload()
          }
        ]
        
    cancel_assignment = (url) ->
        $.post url,
            status: 'cancelled'
            (data) -> alert("success")
