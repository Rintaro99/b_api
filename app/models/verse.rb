class Verse < ApplicationRecord
    belongs_to :book

    
    validates :chapter, presence: true, numericality: { onle_integer: true, greater_than: 0 }
    validates :verse, presence: true, numericality: { onle_integer: true, greater_than: 0 }, uniqueness: { scope: [:book_id, :chapter] }
    validates :text, presence: true, length: { maximum: 1000 }

    scope :by_book_and_chapter, ->(book_id, chapter) {
        where(book_id: book_id, chapter: chapter).order(:verse)
    }
end