class PopulateUrlScores < ActiveRecord::Migration[7.0]
  def change
    Url.all.in_batches(of: 1000) do |batch|
      batch.each do |url|
        url.update(score: url.tweets.sum(:score))
      end
    end
  end
end
