class Post < ActiveRecord::Base
  attr_accessible :user, :title, :body
  default_scope order 'created_at DESC'

  belongs_to :user

  validates :uuid, presence: true, uniqueness: true, on: :create
  validates :user, presence: true
  validates :title, presence: true
  validates :body, presence: true
  before_validation :set_uuid, on: :create

  private
    def set_uuid
      self.uuid = SecureRandom.uuid if self.uuid.blank?
    end

end
