class AddCommentToValuations < ActiveRecord::Migration
  def change
    add_column :valuations, :comment, :text
  end
end
