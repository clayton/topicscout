class AddBetaFlagToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :beta, :boolean, default: false
  end
end
