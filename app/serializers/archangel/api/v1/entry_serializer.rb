# frozen_string_literal: true

module Archangel
  module Api
    module V1
      class EntrySerializer < ActiveModel::Serializer
        type "entry"

        attributes :value, :available_at
      end
    end
  end
end
