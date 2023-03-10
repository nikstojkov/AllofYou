class Opportunity < ApplicationRecord
  belongs_to :user
  has_many :opportunity_tags, dependent: :destroy
  has_many :tags, through: :opportunity_tags
  has_many :applications, dependent: :destroy
  has_many :artists, through: :applications

  validate :validate_date

  has_one_attached :photo

  def validate_date
    if date.present? && date < Date.today
      errors.add(:date, "Invalid Date")
    end
  end
end
