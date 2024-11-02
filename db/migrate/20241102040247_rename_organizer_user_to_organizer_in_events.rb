class RenameOrganizerUserToOrganizerInEvents < ActiveRecord::Migration[7.1]
  def change
    rename_column :events, :organizer_user_id, :organizer_id
  end
end
