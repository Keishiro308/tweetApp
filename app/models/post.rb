class Post < ApplicationRecord
  belongs_to :user
  has_many :passive_likes, class_name: "Like",
            foreign_key: "post_id", dependent: :destroy
  has_many :liked_users, through: :passive_likes, source: :user
  default_scope -> { order(created_at: :desc) }
  mount_uploader :picture, PictureUploader
  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum: 140}
  validate :picture_size

  private
    def picture_size
      if picture.size > 5.megabytes
        errors.add(:picture, "画像を５MB未満にしてください。")
      end
    end

end
