class AddSearchOperatorConditionsToSearchTerms < ActiveRecord::Migration[7.0]
  def change
    add_column :search_terms, :required, :boolean
    add_column :search_terms, :exact_match, :boolean
  end
end
