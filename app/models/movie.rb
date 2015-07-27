class Movie < ActiveRecord::Base
  has_many :reviews
  
  validates :title, presence: true
  validates :director, presence: true
  validates :runtime_in_minutes,
        numericality: { only_integer: true }
  validates :description, presence: true
  validates :poster_image_url, presence: true
  validates :release_date, presence: true
  validate :release_date_is_in_the_future

  mount_uploader :poster_image_url, ImageUploader

  def review_average    
    if reviews && reviews.size > 0
      reviews.sum(:rating_out_of_ten)/reviews.size
    end
  end

  scope :by_title_or_director, -> (search) { where('title OR director LIKE ?', "%#{search}%") }
  scope :by_duration_short, -> (option) { where('runtime_in_minutes < ?', option) }
  scope :by_duration_medium, -> (duration) { where('runtime_in_minutes BETWEEN 90 AND 120') }
  scope :by_duration_long, -> (option) { where('runtime_in_minutes > ?', "#{option}") }


  # def self.by_title(title)
  #   where('title LIKE ?', "%#{title}%")
  # end

  def self.search(search, option)
    movies = Movie.all

    if !search.blank?
      movies = movies.by_title_or_director(search)
    end

    case option
    when '90'
      movies = movies.by_duration_short(option)
    when 'medium'
      movies = movies.by_duration_medium(option)
    when '120'
      movies = movies.by_duration_long(option)
    end

    movies
  end


  protected 

  def release_date_is_in_the_future
    if release_date.present?
      errors.add(:release_date, "should be in the future") if release_date < Date.today
    end
  end
end
