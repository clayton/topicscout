class CreateTwitterListMemberships < ActiveRecord::Migration[7.0]
  def change
    create_table :twitter_list_memberships, id: :uuid do |t|
      t.string :author_id
      t.uuid :twitter_list_id

      t.timestamps
    end
  end
end
