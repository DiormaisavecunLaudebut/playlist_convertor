class CreateSpotifyTokens < ActiveRecord::Migration[6.0]
  def change
    create_table :spotify_tokens do |t|
      t.string :code
      t.string :refresh_token
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
