class RemoveUntitledUrls < ActiveRecord::Migration[7.0]
  def change
    Url.where(title: nil).destroy_all
  end
end
