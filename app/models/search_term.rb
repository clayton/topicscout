class SearchTerm < ApplicationRecord
  belongs_to :topic
  before_save :sanitize_term

  validates :term, presence: true

  scope :required, -> { where(required: true) }
  scope :optional, -> { where(required: false) }
  scope :exact, -> { where(exact_match: true) }
  scope :fuzzy, -> { where(exact_match: false) }

  def to_query
    return term if term.starts_with?('#')
    return term if term.starts_with?('$')
    return term if term.starts_with?('@')
    return term unless exact_match

    %("#{term}")
  end

  def sanitize_term
    self.term = term.downcase.strip
  end
end
