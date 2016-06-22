class RemovePictureFromItems < ActiveRecord::Migration
  def change
  	remove_column :items, :picture
  end
end
