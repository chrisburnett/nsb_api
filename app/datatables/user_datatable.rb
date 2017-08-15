class UserDatatable < AjaxDatatablesRails::Base

  def_delegators :@view, :edit_admin_user_url, :admin_user_url
  
  def view_columns

    @view_columns ||= {
      id: { source: "User.id", cond: :eq },
      username: { source: "User.username", cond: :like },
      name: { source: "User.name", cond: :like },
      date_registered: { source: "User.created_at" }
    }
  end

  def data
    data = records.map do |user|
      {
        id: user.id,
        username: user.username,
        name: user.name,
        date_registered: user.created_at,
        edit_user_url: edit_admin_user_url(id: user.id),
        user_url: admin_user_url(id: user.id)
      }
    end
    return data
  end

  private

  def get_raw_records
    User.where(is_admin: @options[:admin] || false)
  end

end
