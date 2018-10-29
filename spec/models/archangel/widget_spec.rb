# frozen_string_literal: true

require "rails_helper"

module Archangel
  RSpec.describe Widget, type: :model do
    context "scopes" do
      context ".order_on_name" do
        let(:widget_a) { create(:widget, name: "First Widget") }
        let(:widget_b) { create(:widget, name: "Second Widget") }

        it "orders by name A-Z" do
          expect(described_class.order_on_name(:asc))
            .to eq([widget_a, widget_b])
        end

        it "orders by name Z-A" do
          expect(described_class.order_on_name(:desc))
            .to eq([widget_b, widget_a])
        end
      end

      context ".order_on_slug" do
        let(:widget_a) { create(:widget, slug: "first_widget") }
        let(:widget_b) { create(:widget, slug: "second_widget") }

        it "orders by slug A-Z" do
          expect(described_class.order_on_slug(:asc))
            .to eq([widget_a, widget_b])
        end

        it "orders by slug Z-A" do
          expect(described_class.order_on_slug(:desc))
            .to eq([widget_b, widget_a])
        end
      end
    end
  end
end
