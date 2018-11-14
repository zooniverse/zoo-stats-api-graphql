class RemoveNonEssentialColumnsFromEvents < ActiveRecord::Migration[5.2]
  def change
    remove_column :events, :subject_ids, :string
    remove_column :events, :subject_urls, :string
    remove_column :events, :lang, :string
    remove_column :events, :user_agent, :string
    remove_column :events, :user_name, :string
    remove_column :events, :project_name, :string
    remove_column :events, :board_id, :string
    remove_column :events, :discussion_id, :string
    remove_column :events, :focus_id, :string
    remove_column :events, :focus_type, :string
    remove_column :events, :section, :string
    remove_column :events, :body, :string
    remove_column :events, :url, :string
    remove_column :events, :focus, :string
    remove_column :events, :board, :string
    remove_column :events, :tags, :string
    remove_column :events, :user_zooniverse_id, :string
    remove_column :events, :zooniverse_id, :string
  end
end
