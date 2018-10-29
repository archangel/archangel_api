# frozen_string_literal: true

require "rails_helper"

module Archangel
  RSpec.describe Page, type: :model do
    context "scopes" do
      context ".order_on_published_at" do
        let(:page_a) { create(:page, published_at: 1.week.ago) }
        let(:page_b) { create(:page, published_at: 1.day.ago) }

        it "orders by publication date oldest to newest" do
          expect(described_class.order_on_published_at(:asc))
            .to eq([page_a, page_b])
        end

        it "orders by publication date newest to oldest" do
          expect(described_class.order_on_published_at(:desc))
            .to eq([page_b, page_a])
        end
      end

      context ".order_on_title" do
        let(:page_a) { create(:page, title: "First Page") }
        let(:page_b) { create(:page, title: "Second Page") }

        it "orders by title A-Z" do
          expect(described_class.order_on_title(:asc))
            .to eq([page_a, page_b])
        end

        it "orders by title Z-A" do
          expect(described_class.order_on_title(:desc))
            .to eq([page_b, page_a])
        end
      end
    end
  end
end
