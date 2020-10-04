class CreateDeezerApiCalls < ActiveRecord::Migration[6.0]
  def change
    create_table :deezer_api_calls do |t|
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
