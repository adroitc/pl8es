class Web::DailyciousController < ApplicationController
  
  def list
    @locations = Location.where([
      "restaurant_id IN (?)",
      DailyDish.find(
        :all,
        :select => "restaurant_id",
        :conditions => [
          "display_date = (?)",
          Date.today.to_datetime
        ]
      ).map{|d| d.restaurant_id}
    ])
    render :partial => "list", :formats => [:js]
    return
  end
  
end
