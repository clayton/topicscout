class AddsUriHashToUrls < ActiveRecord::Migration[7.0]
  def change
    add_column :urls, :uri_hash, :string
    add_index :urls, [:topic_id, :uri_hash], unique: true

    Url.all.in_batches(of: 1000) do |batch|
      batch.each do |url|
        next unless url.unwound_url
        next if url.unwound_url.blank?
        next if url.uri_hash.present?

        existing_url = Url.find_by(uri_hash: Digest::SHA2.hexdigest(url.unwound_url))

        next if existing_url.present?
          
        url.update(uri_hash: Digest::SHA2.hexdigest(url.unwound_url))
      end
    end
  end
end
