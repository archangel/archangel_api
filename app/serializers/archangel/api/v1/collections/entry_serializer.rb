# frozen_string_literal: true

module Archangel
  module Api
    module V1
      module Collections
        class EntrySerializer < V1Serializer
          set_type "entry"

          attributes :value, :available_at
        end
      end
    end
  end
end
