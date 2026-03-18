require 'rails_helper'

RSpec.describe "Api::V1::Books", type: :request do
    describe 'GET api/v1/books' do
        context "when book exists" do
            let!(:book) do
                Book.create!(
                    name: "創世記",
                    slug: "genesis",
                    testament: :old_testament,
                    position: 1,
                    total_chapters: 50
                )
            end
            it "return books" do
                get "/api/v1/books"

                expect(response).to have_http_status(:ok)

                json = JSON.parse(response.body)
                expect(json["books"].length).to eq(1)
                expect(json["books"][0]["slug"]).to eq("genesis")
            end
        end

        context "when no books exists" do
            it "returns empty array" do
                get "/api/v1/books"

                json = JSON.parse(response.body)
                expect(json["books"]).to eq([])
            end
        end
    end


    describe 'GET api/v1/books/:slug' do
        context "when book exists" do
            let!(:book) do
                Book.create!(
                    name: "創世記",
                    slug: "genesis",
                    testament: :old_testament,
                    position: 1,
                    total_chapters: 50
                )
            end
            it "returns books" do
                get api_v1_book_path("genesis"), as: :json
                expect(response).to have_http_status(:ok)

                json = JSON.parse(response.body)
                expect(json["book"]["slug"]).to eq("genesis")
            end
        end

        context "when no book exists" do
            it "returns 404 error" do
                get api_v1_book_path("genesis"), as: :json
                expect(response).to have_http_status(:not_found)
            end
        end
    end
end
