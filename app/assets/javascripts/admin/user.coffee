$(document).on "turbolinks:load", ->
    get_dropdown_menu_for_row = (data, type, row, meta) ->
        menu_html = [ 
            "<div class='btn-group'>"
            "    <a href='"+row.edit_admin_user_url+"' type='button' class='btn btn-sm btn-default btn-flat'>Edit</a>"
            "    <button type='button' class='btn btn-sm btn-default btn-flat dropdown-toggle' data-toggle='dropdown'>"
            "        <span class='caret'</class>"
            "    </button>"
            "    <ul class='dropdown-menu'>"
        ]

        menu_html.push "        <li><a href='"+row.user_url+"' data-remote='true' data-method='delete'>Delete user</a></li>"

        menu_html.concat [
            "    </ul>"
            "</div>"
        ]

        return menu_html.join("\n")
             
    users_table = $('#users-table').dataTable
        processing: true
        serverSide: true
        ajax: $('#users-table').data('source')
        pagingType: 'full_numbers'
        columns: [
          {data: 'id'}
          {data: 'username'}
          {data: 'name'}
          {data: 'date_registered'}
          {data: null, sortable: false, render: get_dropdown_menu_for_row, createdCell: (td, cellData, rowData, row, col) ->
            $(td).on "ajax:success", (e, data, status, xhr) ->
                users_table.api().ajax.reload()
            } 
        ]
