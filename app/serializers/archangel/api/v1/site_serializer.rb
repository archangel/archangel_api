# frozen_string_literal: true

module Archangel
  module Api
    module V1
      class SiteSerializer < V1Serializer
        set_type "site"

        attributes :name, :theme, :locale, :meta_keywords, :meta_description

        attribute :logo do |object|
          {
            original: object.logo.url,
            tiny: object.logo.tiny.url,
            small: object.logo.small.url,
            medium: object.logo.medium.url,
            large: object.logo.large.url
          }
        end
      end
    end
  end
end
