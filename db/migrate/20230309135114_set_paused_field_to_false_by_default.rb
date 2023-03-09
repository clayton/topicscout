class SetPausedFieldToFalseByDefault < ActiveRecord::Migration[7.0]
  def change
    change_column_default :topics, :paused, from: nil, to: false
  end
end
