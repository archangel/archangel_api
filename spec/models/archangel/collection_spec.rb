# frozen_string_literal: true

require "rails_helper"

module Archangel
  RSpec.describe Collection, type: :model do
    context "scopes" do
      context ".order_on_name" do
        let(:collection_a) { create(:collection, name: "First Collection") }
        let(:collection_b) { create(:collection, name: "Second Collection") }

        it "orders by name A-Z" do
          expect(described_class.order_on_name(:asc))
            .to eq([collection_a, collection_b])
        end

        it "orders by name Z-A" do
          expect(described_class.order_on_name(:desc))
            .to eq([collection_b, collection_a])
        end
      end

      context ".order_on_slug" do
        let(:collection_a) { create(:collection, slug: "first-collection") }
        let(:collection_b) { create(:collection, slug: "second-collection") }

        it "orders by slug A-Z" do
          expect(described_class.order_on_slug(:asc))
            .to eq([collection_a, collection_b])
        end

        it "orders by slug Z-A" do
          expect(described_class.order_on_slug(:desc))
            .to eq([collection_b, collection_a])
        end
      end
    end
  end
end
