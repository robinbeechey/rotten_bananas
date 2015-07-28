class Movie < ActiveRecord::Base
  has_many :reviews
  
  validates :title, presence: true
  validates :director, presence: true
  validates :runtime_in_minutes,
        numericality: { only_integer: true }
  validates :description, presence: true
  validates :release_date, presence: true
  validate :release_date_is_in_the_future
  validate :one_form_of_image_required

  mount_uploader :poster_image_url, ImageUploader

  def review_average    
    if reviews && reviews.size > 0
      reviews.sum(:rating_out_of_ten)/reviews.size
    end
  end

  scope :by_title_or_director, -> (search) { where('title LIKE ? OR director LIKE ?', "%#{search}%", "%#{search}%") }
  scope :by_duration_short, -> { where("runtime_in_minutes < 90") }
  scope :by_duration_medium, -> { where("runtime_in_minutes BETWEEN 90 AND 120") }
  scope :by_duration_long, -> { where("runtime_in_minutes > 120") }


  # def self.by_title(title)
  #   where('title LIKE ?', "%#{title}%")
  # end

  def self.search(search, option)
    movies = Movie.all

    if !search.blank?
      search.split(' ').each do |query|
        movies = movies.by_title_or_director(query)
      end
    end
    case option.to_s.to_i

    when 1
      movies = movies.by_duration_short
    when 2
      movies = movies.by_duration_medium
    when 3
      movies = movies.by_duration_long
    end

    movies
  end


  protected 

  def one_form_of_image_required
    if !image_url.present? && !poster_image_url.present?
      errors.add(:image_url, "Please upload an image or give an image url")
    end
  end

  def release_date_is_in_the_future
    if release_date.present?
      errors.add(:release_date, "should be in the future") if release_date < Date.today
    end
  end
end
