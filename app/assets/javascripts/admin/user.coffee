$(document).on "turbolinks:load", ->
    get_dropdown_menu_for_row = (data, type, row, meta) ->
        menu_html = [ 
            "<div class='btn-group'>"
            "    <a href='"+row.edit_user_url+"' type='button' class='btn btn-sm btn-default btn-flat'>Edit</a>"
            "    <button type='button' class='btn btn-sm btn-default btn-flat dropdown-toggle' data-toggle='dropdown'>"
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
             
    users_table = $('#users-table').dataTable
        pagingType: 'full_numbers'
        columns: [
          {data: 'username'}
          {data: 'name'}
          {data: 'created_at'}
          # { data: null, sortable: false, render: get_dropdown_menu_for_row, createdCell: (td, cellData, rowData, row, col) ->
          #     $(td).on "ajax:success", (e, data, status, xhr) ->
          #         jobs_table.api().ajax.reload()
          # }
        ]
