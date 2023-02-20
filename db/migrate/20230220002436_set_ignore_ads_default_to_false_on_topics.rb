class SetIgnoreAdsDefaultToFalseOnTopics < ActiveRecord::Migration[7.0]
  def change
    change_column_default :topics, :ignore_ads, false
  end
end
