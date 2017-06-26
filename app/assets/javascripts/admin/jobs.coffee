$ ->
    $('#jobs-table').dataTable
        processing: true
        serverSide: true
        ajax: $('#jobs-table').data('source')
        pagingType: 'full_numbers'
        columns: [
          {data: 'title'}
          {data: 'tenant'}
          {data: 'status', render: (data, type, full, meta) -> return '<span class="label label-'+job_status_class(data)+'">'+data+'</a>'}
        ]
    # pagingType is optional,

    job_status_class = (label) ->
        {
            pending: "default",
            accepted: "primary",
            rejected: "danger",
            cancelled: "danger",
            completed: "success"
        }[label]
