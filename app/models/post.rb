class Post < ActiveRecord::Base
  attr_accessible :user, :title, :body
  default_scope order 'created_at DESC'

  validates :user, presence: true
  validates :title, presence: true
  validates :body, presence: true

  belongs_to :user
end
