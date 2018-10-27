# frozen_string_literal: true

module Archangel
  module Api
    module V1
      module Collections
        class EntriesController < V1Controller
          paginatable(size: 12)

          sort_on :title, internal_name: :order_on_title,
                          type: :scope,
                          scope_params: [:direction]

          before_action :set_collection_resource, only: %i[index show]
          before_action :set_resources, only: %i[index]
          before_action :set_resource, only: %i[show]

          def index
            render_json @entries
          end

          def show
            render_not_found && return if @entry.blank?

            render_json @entry
          end

          protected

          def set_collection_resource
            resource_id = params.fetch(:collection_id)

            @collection = current_site.collections.find_by(slug: resource_id)

            render_not_found && return if @collection.blank?
          end

          def set_resources
            @entries = filtrate(
              @collection.entries.page(page_number).per(page_size)
            )
          end

          def set_resource
            resource_id = params.fetch(:id)

            @entry = @collection.entries.find_by!(id: resource_id)
          end
        end
      end
    end
  end
end
