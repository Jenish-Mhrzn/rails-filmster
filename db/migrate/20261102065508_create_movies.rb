class CreateMovies < ActiveRecord::Migration[7.2]
  def change
    create_table :movies do |t|
      t.string :title
      t.integer :tmdb_id
      t.text :overview
      t.string :poster_path
      t.string :backdrop_path
      t.integer :runtime
      t.date :release_date
      t.float :popularity
      t.bigint :budget
      t.float :vote_average
      t.integer :vote_count
      t.string :homepage

      t.timestamps
    end
    add_index :movies, :tmdb_id, unique: true
  end
end
