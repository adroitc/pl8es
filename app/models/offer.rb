class Offer < ActiveRecord::Base
	belongs_to :dish
	
	serialize :on, Array
	serialize :except, Array
	
	validates :every, inclusion: { in: %w(week day) }
	validates_presence_of :every, :start_date, :end_date, :dish
	
	scope :in_range, ->(range) { where("end_date >= ?", range.first).where("start_date <= ?", range.last) }
	
	
	def self.dates_with_dishes(offers, range)
		# firstly converts the offers to this format:
		# => [ { "dish_id" => 1, "dates" => [ Mon, 13 Apr 2015, Wed, 15 Apr 2015, Fri, 17 Apr 2015 ] },
		#      { "dish_id" => 2, "dates" => [ Mon, 13 Apr 2015, Tue, 14 Apr 2015 ] } ]
		
		offer_arr = Array.new(
			offers.map do |o|
			 { "dish_id" => o.dish_id, "dates" => o.dates(range) }
			end
		)
		
		# further convert them to the desired format:
		# => { 
		#      Mon, 13 Apr 2015 => [1],
		#      Tue, 14 Apr 2015 => [1, 2],
		#      Wed, 15 Apr 2015 => [1],
		#      .
		#      .
		#      .
		#    }
		
		final_hash = {}
		range.each do |date|
			# select the ones who include the desired date -- # get the dish_ids of these elements
			dish_ids = offer_arr.select { |h| h["dates"].include?(date.to_date) }.map { |h| h["dish_id"] }
			final_hash.store(date, dish_ids)
		end
		
		return final_hash
	end
	
	def dates(range = nil, options={})
		recurrence_params = {:every => every, :on => on, :interval => interval, :starts => start_date, :until => end_date}.merge(options)
		
		return Recurrence.new(recurrence_params).events
	end
end
