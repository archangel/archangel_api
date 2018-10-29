# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Pages API", type: :request do
  let(:site) { create(:site) }

  let(:headers) do
    {
      "X-Archangel-Token" => site.id
    }
  end

  context "requesting listing" do
    context "without header token" do
      it "returns an error" do
        get "/api/v1/pages"

        parsed_body = JSON.parse(response.body)

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq("application/vnd.api+json")

        expect(parsed_body["errors"][0]["code"]).to eq(422)
        expect(parsed_body["errors"][0]["title"]).to eq("Unprocessable entity")
        expect(parsed_body["errors"][0]["detail"]).to eq("Unprocessable Entity")
      end
    end

    context "without results" do
      it "returns an empty list" do
        get "/api/v1/pages", headers: headers

        parsed_body = JSON.parse(response.body)

        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq("application/vnd.api+json")

        expect(parsed_body["data"].size).to eq(0)
      end
    end

    context "paginating" do
      before { create_list(:page, 3, site: site) }

      it "allows changing result size" do
        get "/api/v1/pages", params: { page: { size: 1 } },
                             headers: headers

        parsed_body = JSON.parse(response.body)

        expect(response).to have_http_status(200)

        expect(parsed_body["data"].size).to eq(1)
        expect(parsed_body["meta"]["total"]).to eq(3)
      end

      it "allows changing page offset" do
        get "/api/v1/pages", params: { page: { size: 1, number: 2 } },
                             headers: headers

        parsed_body = JSON.parse(response.body)

        expect(response).to have_http_status(200)

        expect(parsed_body["meta"]["prev"]).to eq(1)
        expect(parsed_body["meta"]["current"]).to eq(2)
      end

      it "includes meta information" do
        get "/api/v1/pages", params: { page: { size: 1 } },
                             headers: headers

        parsed_body = JSON.parse(response.body)

        expect(response).to have_http_status(200)

        expect(parsed_body["meta"]["current"]).to eq(1)
        expect(parsed_body["meta"]["prev"]).to be_nil
        expect(parsed_body["meta"]["next"]).to eq(2)
        expect(parsed_body["meta"]["total"]).to eq(3)
        expect(parsed_body["meta"]["first"]).to be_truthy
        expect(parsed_body["meta"]["last"]).to be_falsey
      end

      it "includes links information" do
        get "/api/v1/pages", params: { page: { size: 2 } },
                             headers: headers

        parsed_body = JSON.parse(response.body)

        expect(response).to have_http_status(200)

        self_first = "http://www.example.com/api/v1/pages?page[number]=1&page[size]=2"
        next_last = "http://www.example.com/api/v1/pages?page[number]=2&page[size]=2"

        expect(parsed_body["links"]["self"]).to eq(self_first)
        expect(parsed_body["links"]["first"]).to eq(self_first)
        expect(parsed_body["links"]["prev"]).to be_nil
        expect(parsed_body["links"]["next"]).to eq(next_last)
        expect(parsed_body["links"]["last"]).to eq(next_last)
      end
    end

    context "including" do
      # No includes
    end

    context "sorting" do
      # No sorting
    end

    context "filtering" do
      # No filtering
    end
  end

  context "requesting detail" do
    context "with record not found" do
      it "returns a 404" do
        get "/api/v1/pages/999", headers: headers

        parsed_body = JSON.parse(response.body)

        expect(response).to have_http_status(:not_found)
        expect(response.content_type).to eq("application/vnd.api+json")

        expect(parsed_body["errors"][0]["code"]).to eq(404)
        expect(parsed_body["errors"][0]["title"]).to eq("Not found")
        expect(parsed_body["errors"][0]["detail"]).to eq("Record not found")
      end
    end

    context "with available record" do
      it "returns content" do
        page = create(:page, site: site)

        get "/api/v1/pages/#{page.slug}", headers: headers

        parsed_body = JSON.parse(response.body)

        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq("application/vnd.api+json")

        expect(parsed_body["data"]["id"]).to eq(page.id.to_s)
        expect(parsed_body["data"]["type"]).to eq("page")

        expect(parsed_body["data"]["attributes"]["slug"]).to eq(page.slug)
        expect(parsed_body["data"]["attributes"]["title"]).to eq(page.title)
        expect(parsed_body["data"]["attributes"]["content"]).to eq(page.content)
        expect(parsed_body["data"]["attributes"]["content"]).to eq("foo")
      end
    end
  end

  context "posting new resource" do
    context "succeffully valid content" do
      it "returns content" do
        page = create(:page, site: site)

        post "/api/v1/pages/#{page.id}", headers: headers

        parsed_body = JSON.parse(response.body)

        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq("application/vnd.api+json")
        expect(parsed_body["data"]["attributes"]["foo"]).to eq("bar")
      end
    end

    context "fails with error" do
      it "returns content" do
        page = create(:page, site: site)

        post "/api/v1/pages/#{page.id}", headers: headers

        parsed_body = JSON.parse(response.body)

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq("application/vnd.api+json")
        expect(parsed_body["error"][0]["message"]).to eq("Broked")
      end
    end
  end

  context "posting resource update" do
    context "succeffully valid content" do
      it "returns content" do
        page = create(:page, site: site)

        put "/api/v1/pages/#{page.id}", headers: headers

        parsed_body = JSON.parse(response.body)

        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq("application/vnd.api+json")
        expect(parsed_body["data"]["attributes"]["foo"]).to eq("bar")
      end
    end

    context "fails with error" do
      it "returns content" do
        page = create(:page, site: site)

        put "/api/v1/pages/#{page.id}", headers: headers

        parsed_body = JSON.parse(response.body)

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq("application/vnd.api+json")
        expect(parsed_body["error"][0]["message"]).to eq("Broked")
      end
    end
  end

  context "deleting resource" do
    it "responds with 204 status code" do
      page = create(:page, site: site)

      delete "/api/v1/pages/#{page.id}", headers: headers

      expect(response).to have_http_status(:no_content)
      expect(response.content_type).to eq("application/vnd.api+json")
    end
  end
end
