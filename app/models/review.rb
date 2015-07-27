class Review < ActiveRecord::Base
  belongs_to :user, dependent: :destroy
  belongs_to :movie, dependent: :destroy

  validates :user, presence: true
  validates :movie, presence: true
  validates :text, presence: true  
  validates :rating_out_of_ten, :inclusion => 1..10

end
