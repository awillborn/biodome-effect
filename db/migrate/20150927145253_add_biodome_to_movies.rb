class AddBiodomeToMovies < ActiveRecord::Migration
  def change
    add_column :movies, :biodome, :boolean, default: false
  end
end
