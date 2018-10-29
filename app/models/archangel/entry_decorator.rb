# frozen_string_literal: true

Archangel::Entry.class_eval do
  scope :order_on_available_at, ->(direction) { order(available_at: direction) }
  scope :order_on_position, ->(direction) { order(position: direction) }
end
