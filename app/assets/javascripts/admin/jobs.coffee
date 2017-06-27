$ ->
    $('#jobs-table').dataTable
        processing: true
        serverSide: true
        ajax: $('#jobs-table').data('source')
        pagingType: 'full_numbers'
        columns: [
          {data: 'title'}
          {data: 'tenant'}
          {data: 'status', render: (data, type, full, meta) ->
            data = "unassigned" if !data?
            status_map = {
                unassigned: "default",
                pending: "info",
                accepted: "primary",
                rejected: "danger",
                cancelled: "danger",
                completed: "success"
            }
            return '<span class="label label-'+status_map[data]+'">'+data+'</span>' }
        ]

