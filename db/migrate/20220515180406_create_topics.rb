class CreateTopics < ActiveRecord::Migration[7.0]
  def change
    create_table :topics, id: :uuid do |t|
      t.string :topic

      t.timestamps
    end
  end
end
