# frozen_string_literal: true

module Archangel
  module Api
    module V1
      class CollectionSerializer < V1Serializer
        set_type "collection"

        has_many :entries
        has_many :fields

        attributes :name, :slug
      end
    end
  end
end
