class Offer < ActiveRecord::Base
	belongs_to :dish
	
	serialize :on, Array
	serialize :except, Array
	
	validates :every, inclusion: { in: %w(week day) }
	validates_presence_of :every, :start_date, :end_date
	
	def dates(options={})
		Recurrence.new({:every => every, :on => on, :interval => interval, :repeat => repeat, :starts => start_date, :until => end_date}.merge(options)).events
	end
end
