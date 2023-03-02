class SetDefaultTimezoneForUsers < ActiveRecord::Migration[7.0]
  def change
    User.update_all(timezone: 'UTC')
  end
end
