# frozen_string_literal: true

module Archangel
  module Api
    module V1
      class CollectionsController < V1Controller
        paginatable(size: 12)

        sort_on :title, internal_name: :order_on_title,
                        type: :scope,
                        scope_params: [:direction]

        before_action :set_resources, only: %i[index]
        before_action :set_resource, only: %i[show]

        def index
          render_json @collections, include: options_include
        end

        def show
          render_not_found && return if @collection.blank?

          render_json @collection
        end

        protected

        def set_resources
          @collections = filtrate(
            current_site.collections
                        .includes(query_includes)
                        .page(page_number).per(page_size)
          )
        end

        def set_resource
          resource_id = params.fetch(:id)

          @collection = current_site.collections
                                    .includes(query_includes)
                                    .find_by(slug: resource_id)
        end
      end
    end
  end
end
