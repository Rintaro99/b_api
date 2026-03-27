class Api::V1::ChaptersController < ApplicationController
    before_action :set_book, only: [ :show ]

    def show
        @verses = Verse.by_book_and_chapter( @book.id, params[:id] )
        render json: { 
            book: {
                name: @book.name,
                slug: @book.slug
            },
            chapter: params[:id],
            verses: @verses.map do |v|
                {
                    verse: v.verse,
                    text: v.text
                }
            end
         }
    end

    private

    def set_book
        @book = Book.find_by!(slug: params[:slug])
    end
end
