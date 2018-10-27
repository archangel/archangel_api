# frozen_string_literal: true

module Archangel
  module Api
    module V1
      class PageSerializer < ActiveModel::Serializer
        type "page"

        attributes :title, :path, :content, :homepage, :meta_keywords,
                   :meta_description

        def path
          object.homepage? ? "/" : "/#{object.path}"
        end
      end
    end
  end
end
