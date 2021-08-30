class Url < ApplicationRecord

  has_many :visits

  validates :token, :original, presence: true
  validates :token, uniqueness: true
end
