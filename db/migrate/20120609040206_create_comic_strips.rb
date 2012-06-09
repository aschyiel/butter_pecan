class CreateComicStrips < ActiveRecord::Migration
  def change
    create_table :comic_strips do |t|
      t.string :title
      t.text :content

      t.timestamps
    end
  end
end
