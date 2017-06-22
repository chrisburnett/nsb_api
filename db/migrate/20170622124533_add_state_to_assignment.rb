# Assignments are created by office staff, and then contractors have
# the ability to accept or reject them. Therefore, we store a status
# field [pending|accepted|rejected], a link to the contractor user
# (distinct from the user who created the assignment) and the date of
# the contractor's response (if not pending)

# this change was required because previously there was an assumption
# that contractors themselves see open jobs and choose the ones they
# want.

class AddStateToAssignment < ActiveRecord::Migration[5.1]
  def change
    add_column :assignments, :status, :string
    add_column :assignments, :contractor_id, :integer
    add_column :assignments, :response_date, :datetime
    add_foreign_key :assignments, :users, column: :contractor_id
  end
end
