class ChangeTweetsSavedDefaults < ActiveRecord::Migration[7.0]
  def change
    change_column_default :tweets, :saved, from: nil, to: false
    change_column_null :tweets, :saved, true
  end
end
