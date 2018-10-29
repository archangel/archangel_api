# frozen_string_literal: true

module Archangel
  module Api
    module V1
      class PageSerializer < V1Serializer
        set_type "page"

        attribute :path do |object|
          object.homepage? ? "/" : "/#{object.path}"
        end

        attribute :url do |object|
          "http://localhost:3000" + (object.homepage? ? "" : "/#{object.path}")
        end

        attributes :title, :content, :homepage, :meta_keywords,
                   :meta_description
      end
    end
  end
end
