# class ItemPrice < ActiveRecord::Base
#   # Relationships
#   belongs_to :item
  
#   # Scopes
#   scope :current,  		-> { order(:name) }
#   scope :for_date,  -> (date) 
#   scope :for_item  -> (item_id) { where("item_id: ?", item_id}
#   scope :chronological, -> { order(start_date: :desc) }

#   # Validations
#   validates_date :start_date, :end_date

#   # Other methods
# end
