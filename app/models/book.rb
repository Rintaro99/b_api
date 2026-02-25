class Book < ApplicationRecord
    has_many :verses, dependent: :restrict_with_exception

    enum testament: { old_testament: 0, new_testament: 1 }

    validates :name, presence: true
    validates :slug, presence: true, uniqueness: true
    validates :testament, presence: true
    validates :position, presence: true, uniqueness: true, numericality: { only_integer: true }
    validates :total_chapters, presence: true, numericality: { only_integer: true, greater_than: 0 }
end
