require "rails_helper"

RSpec.describe Verse, type: :model do
    # データ入力
    let(:book) do
        Book.create!(
            name: "創世記",
            slug: "genesis",
            testament: :old_testament,
            position: 1,
            total_chapters: 50
        )
    end
    let(:verse) do
        Verse.new(
            book: book,
            chapter: 1,
            verse: 1,
            text: "はじめに神は天と地とを創造された。"
        )
    end

    # 関係性
    describe "associations" do
        it "is invalid without a book" do
            verse.book = nil
            expect(verse).not_to be_valid
        end
    end

    # バリデーション
    describe "validations" do
        # OKパターン
        it "is valid with valid attributes" do
            expect(verse).to be_valid
        end
        # 章
        describe "chapter" do
            describe "presence" do
                context "when nil" do
                    before { verse.chapter = nil }
                    it "is invalid" do
                        expect(verse).not_to be_valid
                    end
                end
            end

            describe "numecality" do
                context "when 0" do
                    before { verse.chapter = 0 }
                    it "is invalid" do
                        expect(verse).not_to be_valid
                    end
                end
                context "when not integer" do
                    before { verse.chapter = 1.5 }
                    it "is invalid" do
                        expect(verse).not_to be_valid
                    end
                end
            end
        end
        # 節
        describe "verse" do
            describe "presence" do
                context "when nil" do
                    before { verse.verse = nil }
                    it "is invalid" do
                        expect(verse).not_to be_valid
                    end
                end
            end

            describe "numericality" do
                context "when 0" do
                    before { verse.verse = 0 }
                    it "is invalid" do
                        expect(verse).not_to be_valid
                    end
                end
                context "when not integer" do
                    before { verse.verse = 1.5 }
                    it "is invalid" do
                        expect(verse).not_to be_valid
                    end
                end
            end

            describe "uniqueness" do
                before do
                    Verse.create!(
                        book: book,
                        chapter: 1,
                        verse: 1,
                        text: "はじめに神は天と地とを創造された。"
                    )
                end
                context "when same book and same chapter" do
                    it "is invalid" do
                        duplicate = Verse.new(
                            book: book,
                            chapter: 1,
                            verse: 1,
                            text: "はじめに神は天と地とを創造された。"
                        )
                        expect(duplicate).not_to be_valid
                    end
                end
                context "when same book but different chapter" do
                    it "is valid" do
                        different = Verse.new(
                            book: book,
                            chapter: 2,
                            verse: 1,
                            text: "こうして天と地と、その万象とが完成した。"
                        )
                        expect(different).to be_valid
                    end
                end
                context "when different book but same chapter" do
                    let(:other_book) do
                        Book.create!(
                            name: "出エジプト記",
                            slug: "exodus",
                            testament: :old_testament,
                            position: 2,
                            total_chapters: 40
                        )
                    end
                    it "is valid" do
                        different = Verse.new(
                            book: other_book,
                            chapter: 1,
                            verse: 1,
                            text: "さて、ヤコブと共に、おのおのその家族を伴って、エジプトへ行ったイスラエルの子らの名は次のとおりである。"
                        )
                        expect(different).to be_valid
                    end
                end
            end
        end
        # 本文
        describe "text" do
            it "is invalid when nil" do
                verse.text = nil
                expect(verse).not_to be_valid
            end
        end
    end

    describe "scopes" do
        describe ".by_book_and_chapter" do
            let(:other_book) do
                Book.create!(
                    name: "出エジプト記",
                    slug: "exodus",
                    testament: :old_testament,
                    position: 2,
                    total_chapters: 40
                )
            end
            before do
                # 対象データ（順番バラバラに入れる）
                Verse.create!(
                    book: book,
                    chapter: 1,
                    verse: 2,
                    text: "地は形なく、むなしく、やみが淵のおもてにあり、神の霊が水のおもてをおおっていた。"
                )
                Verse.create!(
                    book: book,
                    chapter: 1,
                    verse: 1,
                    text: "はじめに神は天と地とを創造された。"
                )
                # ノイズ
                Verse.create!(
                    book: book,
                    chapter: 2,
                    verse: 1,
                    text: "地は形なく、むなしく、やみが淵のおもてにあり、神の霊が水のおもてをおおっていた。"
                )
                Verse.create!(
                    book: other_book,
                    chapter: 1,
                    verse: 1,
                    text: "地は形なく、むなしく、やみが淵のおもてにあり、神の霊が水のおもてをおおっていた。"
                )
            end
            it "returns verses filtered by book and chapter ordered by verse" do
                result = Verse.by_book_and_chapter(book.id, 1)
                expect(result.map(&:verse)).to eq([ 1, 2 ])
            end
        end
    end
end
