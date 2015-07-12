class AddNicknameToUsers < ActiveRecord::Migration
  def change
    add_column :users, :nickname, :string, default: nil
  end
end
