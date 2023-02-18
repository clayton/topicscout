class AddCollectionAssociationToTweets < ActiveRecord::Migration[7.0]
  def change
    add_reference :tweets, :collection, type: :uuid, foreign_key: false, null: true
  end
end
