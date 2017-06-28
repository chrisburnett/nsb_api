$ ->
    $('#jobs-table').dataTable
        processing: true
        serverSide: true
        ajax: $('#jobs-table').data('source')
        pagingType: 'full_numbers'
        columns: [
          {data: 'title'}
          {data: 'tenant'}
          {data: 'contractor'}
          {data: 'status', searchable: true, render: (data, type, full, meta) ->
            data = "unassigned" if !data?
            status_map = {
                unassigned: "default",
                pending: "info",
                accepted: "primary",
                rejected: "danger",
                cancelled: "danger",
                completed: "success"
            }
            return '<span class="label label-'+status_map[data]+'">'+data+'</span>'
          }
          {data: null, render: (data,type,full,meta) ->
            return """
                <div class="btn-group">
                    <button type="button" class="btn btn-sm btn-default btn-flat">Edit</button>
                    <button type="button" class="btn btn-sm btn-default btn-flat dropdown-toggle" data-toggle="dropdown">
                        <span class="caret"</class>
                    </button>
                    <ul class="dropdown-menu">
                        <li><a href="#">Edit</a></li>
                        <li><a href="#">Delete</a></li>
                    </ul>
                </div>
                """ }
        ]
