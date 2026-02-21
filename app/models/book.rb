class Book < ApplicationRecord
    has_many :verses, dependent: :restrict_with_exception

    validates :name, presence: true
    validates :slug, presence: true, uniqueness: true
    validates :total_chapters, presence: true, numericality: { onle_integer: true, greater_than: 0 }
    validates :position, presence: true, uniqueness: true, numericality{ onle_integer: true }
end