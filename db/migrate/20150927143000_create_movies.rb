class CreateMovies < ActiveRecord::Migration
  def change
    create_table :movies do |t|
      t.string  :title,   null: false
      t.integer :imdb_id, null: false
      t.text    :ratings, null: false, array: true
      t.timestamps
    end
  end
end
