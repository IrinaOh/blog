class CreatePostsTable < ActiveRecord::Migration[5.0]
  def change
  	create_table :posts do |t|
  		t.string :messages, :limit=> 150
  		t.integer :user_id 
  		t.datetime :created_post
  	end
  end
end
