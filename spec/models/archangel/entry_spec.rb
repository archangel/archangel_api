# frozen_string_literal: true

require "rails_helper"

module Archangel
  RSpec.describe Entry, type: :model do
    context "scopes" do
      context ".order_on_available_at" do
        let(:entry_a) { create(:entry, available_at: 1.week.ago) }
        let(:entry_b) { create(:entry, available_at: 1.day.ago) }

        it "orders by available data oldest to newest" do
          expect(described_class.order_on_available_at(:asc))
            .to eq([entry_a, entry_b])
        end

        it "orders by available data newest to oldest" do
          expect(described_class.order_on_available_at(:desc))
            .to eq([entry_b, entry_a])
        end
      end

      context ".order_on_position" do
        let(:entry_a) { create(:entry) }
        let(:entry_b) { create(:entry) }

        it "orders by position low to high" do
          expect(described_class.order_on_position(:asc))
            .to eq([entry_b, entry_a])
        end

        it "orders by position high to low" do
          expect(described_class.order_on_position(:desc))
            .to eq([entry_a, entry_b])
        end
      end
    end
  end
end
