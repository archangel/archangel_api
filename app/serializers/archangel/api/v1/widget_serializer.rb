# frozen_string_literal: true

module Archangel
  module Api
    module V1
      class WidgetSerializer < ActiveModel::Serializer
        type "widget"

        attributes :name, :slug, :content
      end
    end
  end
end
