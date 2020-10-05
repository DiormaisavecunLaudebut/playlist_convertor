class AddDeezerClientToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :deezer_client, :string
  end
end
