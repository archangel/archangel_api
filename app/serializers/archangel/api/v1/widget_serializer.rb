# frozen_string_literal: true

module Archangel
  module Api
    module V1
      class WidgetSerializer < V1Serializer
        set_type "widget"

        attributes :slug, :name, :content
      end
    end
  end
end
