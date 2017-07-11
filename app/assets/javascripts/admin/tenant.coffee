$(document).on "turbolinks:load", ->
    get_dropdown_menu_for_row = (data, type, row, meta) ->
        menu_html = [ 
            "<div class='btn-group'>"
            "    <a href='"+row.edit_tenant_url+"' type='button' class='btn btn-sm btn-default btn-flat'>Edit</a>"
            "    <button type='button' class='btn btn-sm btn-default btn-flat dropdown-toggle' data-toggle='dropdown'>"
            "        <span class='caret'</class>"
            "    </button>"
            "    <ul class='dropdown-menu'>"
        ]

        menu_html.push "        <li><a href='"+row.tenant_url+"' data-remote='true' data-method='delete'>Delete tenant</a></li>"

        menu_html.concat [
            "    </ul>"
            "</div>"
        ]

        return menu_html.join("\n")
             
    tenants_table = $('#tenants-table').dataTable
        processing: true
        serverSide: true
        ajax: $('#tenants-table').data('source')
        pagingType: 'full_numbers'
        columns: [
          {data: 'id'}
          {data: 'name'}
          {data: 'address'}
          {data: 'notes'}
          {data: null, sortable: false, render: get_dropdown_menu_for_row, createdCell: (td, cellData, rowData, row, col) ->
            $(td).on "ajax:success", (e, data, status, xhr) ->
                tenants_table.api().ajax.reload()
            } 
        ]
