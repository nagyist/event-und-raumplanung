class EventSuggestion < ActiveRecord::Base
  include DateTimeAttribute
  include EventModule

  has_and_belongs_to_many :rooms
  has_one :event
  accepts_nested_attributes_for :rooms 

  date_time_attribute :starts_at
  date_time_attribute :ends_at

  validate :dates_cannot_be_in_the_past,:start_before_end_date
  validates :starts_at, presence: true
  validates :ends_at, presence: true
  
end