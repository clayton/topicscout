class AddsCollectionRelationshipToTweets < ActiveRecord::Migration[7.0]
  def change
    add_reference :tweets, :collection, type: :uuid, foreign_key: true
  end
end
