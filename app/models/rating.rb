class Rating < ActiveRecord::Base
  belongs_to :node

  def rating_array
  	[self.rating1, self.rating2, self.rating3, self.rating4]
  end
end
