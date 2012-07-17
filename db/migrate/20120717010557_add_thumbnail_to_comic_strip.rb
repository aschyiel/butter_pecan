class AddThumbnailToComicStrip < ActiveRecord::Migration
# def change
# end
  def up
    add_column :comic_strips, :thumbnail, :string

    #
    # set the default thumbnail image for existing comics.
    #
    default_thumbnail = "http://img213.imageshack.us/img213/7239/bubble3.png";
    ComicStrip.all.each do |strip|
      strip.update_attribute( :thumbnail, default_thumbnail );
    end

  end

  def down
    remove_column :comic_strips, :thumbnail
  end 
end
