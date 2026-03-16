class Api::V1::BooksController < ApplicationController
    before_action :set_book, only: [ :show ]

    def index
        books = Book.all
        render json: { books: books }
    end

    def show
        render json: { book: @book }
    end

    private

    def set_book
        @book = Book.find_by!(slug: params[:slug])
    end
end
