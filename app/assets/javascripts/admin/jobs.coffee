$ ->
    $('#jobs-table').dataTable
        processing: true
        serverSide: true
        ajax: $('#jobs-table').data('source')
        pagingType: 'full_numbers'
        columns: [
          {data: 'name'}
          {data: 'tenant'}
          {data: 'status'}
    ]
    # pagingType is optional,
