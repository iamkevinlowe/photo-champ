class Challenge < ActiveRecord::Base
  belongs_to :challenger, class_name: "Photo"
  belongs_to :challenged, class_name: "Photo"
end
