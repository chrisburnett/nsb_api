class TenantDatatable < AjaxDatatablesRails::Base

  def_delegators :@view, :edit_admin_tenant_url, :admin_tenant_url
  
  def view_columns

    @view_columns ||= {
      id: { source: "Tenant.id", cond: :eq },
      name: { source: "Tenant.name", cond: :like },
      address: { source: "Tenant.address", cond: :like },
      notes: { source: "Tenant.notes", cond: :like }
    }
  end

  def data
    data = records.map do |t|
      {
        id: t.id,
        name: t.name,
        address: t.address,
        notes: t.notes,
        edit_tenant_url: edit_admin_tenant_url(id: t.id),
        tenant_url: admin_tenant_url(id: t.id)
      }
    end
    return data
  end

  private

  def get_raw_records
    Tenant.all
  end

end
