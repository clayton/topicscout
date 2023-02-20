class NegativeSearchTerm < ApplicationRecord
  belongs_to :topic
  before_save :sanitize_term

  validates :term, presence: true

  def sanitize_term
    self.term = term.downcase.strip
  end

  def to_query
    keyword = term.downcase
    keyword = "\"#{keyword}\"" if keyword.include?(' ')
    "-#{keyword}"
  end
end
