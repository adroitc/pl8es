class Offer < ActiveRecord::Base
	belongs_to :dish
	
	serialize :on, Array
	serialize :except, Array
	
	validates :every, inclusion: { in: %w(week day) }
	validates_presence_of :every, :start_date, :end_date, :dish
	
	scope :in_range, ->(range) { where("end_date >= ?", range.first).where("start_date <= ?", range.last) }
	
	def dates(range = nil, options={})
		recurrence_params = {:every => every, :on => on, :interval => interval, :repeat => repeat, :starts => start_date, :until => end_date}.merge(options)
		
		if range
			Recurrence.new(recurrence_params.merge(:starts => range.first, :until => range.last)).events
		else
			Recurrence.new(recurrence_params).events
		end
	end
	end
end
