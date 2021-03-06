class SearchTerm < ApplicationRecord
  belongs_to :topic
  before_save :sanitize_term

  validates :term, presence: true

  def sanitize_term
    self.term = term.downcase.strip
  end
end
