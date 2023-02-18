class Url < ApplicationRecord
  belongs_to :tweet

  def hostname
    return unless unwound_url

    URI.parse(unwound_url).host
  end
end
