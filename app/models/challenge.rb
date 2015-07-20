class Challenge < ActiveRecord::Base
  belongs_to :challenger, class_name: "Photo"
  belongs_to :challenged, class_name: "Photo"

  before_save :default_length

  private

  def default_length
    self.length ||= 6
  end
end
