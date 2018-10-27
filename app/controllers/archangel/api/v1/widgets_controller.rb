# frozen_string_literal: true

module Archangel
  module Api
    module V1
      class WidgetsController < V1Controller
        paginatable(size: 12)

        sort_on :title, internal_name: :order_on_title,
                        type: :scope,
                        scope_params: [:direction]
        sort_on :published_at, internal_name: :order_on_published_at,
                               type: :scope,
                               scope_params: [:direction]

        before_action :set_resources, only: %i[index]
        before_action :set_resource, only: %i[show]

        def index
          render_json @widgets
        end

        def show
          render_not_found && return if @widget.blank?

          render_json @widget
        end

        protected

        def set_resources
          @widgets = filtrate(
            current_site.widgets.page(page_number).per(page_size)
          )
        end

        def set_resource
          resource_id = params.fetch(:id)

          @widget = current_site.widgets.find_by(slug: resource_id)
        end
      end
    end
  end
end
