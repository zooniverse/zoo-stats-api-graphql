class AddUserGroupIdToEvents < ActiveRecord::Migration[5.2]
  def change
    add_column(:events, :group_id, :bigint)
  end
end
