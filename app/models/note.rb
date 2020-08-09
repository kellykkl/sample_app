class Note < ApplicationRecord
	belongs_to :article
	belongs_to :user
	has_one_attached :image
	validates :image,   content_type: { in: %w[image/jpeg image/gif image/png],
	                                  message: "must be a valid image format" },
	                  size:         { less_than: 5.megabytes,
	                                  message:   "should be less than 5MB" } 

  def display_image
    image.variant(resize_to_limit: [400, 400])
  end

end
