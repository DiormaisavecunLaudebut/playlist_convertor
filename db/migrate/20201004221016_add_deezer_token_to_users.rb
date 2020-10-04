class AddDeezerTokenToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :deezer_token, :string
  end
end
