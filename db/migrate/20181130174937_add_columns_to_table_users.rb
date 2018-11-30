class AddColumnsToTableUsers < ActiveRecord::Migration[5.2]

  def change
    add_column :users, :avatar_url, :text
    add_column :users, :description, :string
  end

end
