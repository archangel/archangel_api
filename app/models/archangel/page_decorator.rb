# frozen_string_literal: true

Archangel::Page.class_eval do
  scope :order_on_published_at, ->(direction) { order(published_at: direction) }
  scope :order_on_title, ->(direction) { order(title: direction) }
end
