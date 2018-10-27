# frozen_string_literal: true

module Archangel
  module Api
    module V1
      class CollectionSerializer < ActiveModel::Serializer
        type "collection"

        has_many :entries

        attributes :name, :slug
      end
    end
  end
end
