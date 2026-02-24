require "rails_helper"

RSpec.describe Book, type: :model do
    describe "associations" do
        it "raises an error when destroying a book with verses" do
            book = Book.create!(
                name: "創世記",
                slug: "genesis",
                testament: :old_testament,
                total_chapters: 50,
                position: 1
            )
            book.verses.create!(
                chapter: 1,
                verse: 1,
                text: "はじめに神は天と地を創造された。"
            )
            expect { book.destroy }.to raise_error(ActiveRecord::DeleteRestrictionError)
        end
    end

    describe "validations" do
        it "is valid with all required attributes" do
            book = Book.new(
                name: "創世記",
                slug: "genesis",
                testament: :old_testament,
                total_chapters: 50,
                position: 1
            )
            expect(book).to be_valid
        end

        describe "name" do
            it "is invalid without a name" do
                book = Book.new(
                    name: nil,
                    slug: "genesis",
                    total_chapters: 50,
                    position: 1
                )
                expect(book).not_to be_valid
            end
        end

        describe "slug" do
            it "is invalid without a slug" do
                book = Book.new(
                    name: "創世記",
                    slug: nil,
                    testament: :old_testament,
                    total_chapters: 50,
                    position: 1
                )
                expect(book).not_to be_valid
            end

            it "is invalid with a duplicate slug" do
                Book.create!(
                    name: "創世記",
                    slug: "genesis",
                    testament: :old_testament,
                    total_chapters: 50,
                    position: 1
                )
                book = Book.new(
                    name: "出エジプト記",
                    slug: "genesis",
                    testament: :old_testament,
                    total_chapters: 40,
                    position: 2
                )
                expect(book).not_to be_valid
            end
        end

        describe "testament" do
            it "is invalid without a testament" do
                book = Book.new(
                    name: "創世記",
                    slug: "genesis",
                    testament: nil,
                    total_chapters: 50,
                    position: 1
                )
                expect(book).not_to be_valid
            end
        end

        describe "position" do
            it "is invalid without a position" do
                book = Book.new(
                    name: "創世記",
                    slug: "genesis",
                    testament: :old_testament,
                    total_chapters: 50,
                    position: nil
                )
                expect(book).not_to be_valid
            end

            it "is invalid with a duplicate position" do
                Book.create!(
                    name: "創世記",
                    slug: "genesis",
                    testament: :old_testament,
                    total_chapters: 50,
                    position: 1
                )
                book = Book.new(
                    name: "出エジプト記",
                    slug: "exodus",
                    testament: :old_testament,
                    total_chapters: 40,
                    position: 1
                )
                expect(book).not_to be_valid
            end

            it "is invalid with a decimal value" do
                book = Book.new(
                    name: "創世記",
                    slug: "genesis",
                    testament: :old_testament,
                    total_chapters: 50,
                    position: 1.5
                )
                expect(book).not_to be_valid
            end

            it "is invalid with a non-integer value" do
                book = Book.new(
                    name: "創世記",
                    slug: "genesis",
                    testament: :old_testament,
                    total_chapters: 50,
                    position: "abc"
                )
                expect(book).not_to be_valid
            end
        end

        describe "total_chapters" do
            it "is invalid without total_chapters" do
                book = Book.new(
                    name: "創世記",
                    slug: "genesis",
                    testament: :old_testament,
                    total_chapters: nil,
                    position: 1
                )
                expect(book).not_to be_valid
            end

            it "is invalid with a a decimal value" do
                book = Book.new(
                    name: "創世記",
                    slug: "genesis",
                    testament: :old_testament,
                    total_chapters: 1.5,
                    position: 1
                )
                expect(book).not_to be_valid
            end

            it "is invalid with a non-integer value" do
                book = Book.new(
                    name: "創世記",
                    slug: "genesis",
                    testament: :old_testament,
                    total_chapters: "aaa",
                    position: 1
                )
                expect(book).not_to be_valid
            end

            it "is invalid when total_chapters is 0" do
                book = Book.new(
                    name: "創世記",
                    slug: "genesis",
                    testament: :old_testament,
                    total_chapters: 0,
                    position: 1
                )
                expect(book).not_to be_valid
            end
        end
    end
end