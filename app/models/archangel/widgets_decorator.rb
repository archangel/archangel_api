# frozen_string_literal: true

Archangel::Widget.class_eval do
  scope :order_on_name, ->(direction) { order(name: direction) }
  scope :order_on_slug, ->(direction) { order(slug: direction) }
end
