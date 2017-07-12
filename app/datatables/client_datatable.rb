class ClientDatatable < AjaxDatatablesRails::Base

  def_delegators :@view, :edit_admin_client_url, :admin_client_url
  
  def view_columns

    @view_columns ||= {
      id: { source: "Client.id", cond: :eq },
      name: { source: "Client.name", cond: :like },
      address: { source: "Client.address", cond: :like },
      notes: { source: "Client.notes", cond: :like }
    }
  end

  def data
    data = records.map do |c|
      {
        id: c.id,
        name: c.name,
        address: c.address,
        notes: c.notes,
        edit_client_url: edit_admin_client_url(id: c.id),
        client_url: admin_client_url(id: c.id)
      }
    end
    return data
  end

  private

  def get_raw_records
    Client.all
  end

end
