# frozen_string_literal: true

Archangel::Collection.class_eval do
  scope :order_on_title, ->(direction) { order(title: direction) }
end
