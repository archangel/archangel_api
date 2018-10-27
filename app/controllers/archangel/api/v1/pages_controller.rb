# frozen_string_literal: true

module Archangel
  module Api
    module V1
      class PagesController < V1Controller
        paginatable(size: 12)

        sort_on :title, internal_name: :order_on_title,
                        type: :scope,
                        scope_params: [:direction]
        sort_on :published_at, internal_name: :order_on_published_at,
                               type: :scope,
                               scope_params: [:direction]

        before_action :set_resources, only: %i[index]
        before_action :set_resource, only: %i[destroy show update]
        before_action :set_new_resource, only: %i[create]

        def index
          # render json: @pages, meta: @pages, links: @pages
          render_json @pages
        end

        def show
          # render json: @page, links: @pages

          render_not_found && return if @page.blank?

          render_json @page
        end

        def create
          if @page.save
            render_json(@page, status: :created)
          else
            render_error(@page.errors, status: :unprocessable_entity)
          end
        end

        def update
          if @page.update(resource_params)
            render_json(@page, status: :ok)
          else
            render_error(@page.errors, status: :unprocessable_entity)
          end
        end

        def destroy
          @page.destroy

          head :no_content
        end

        protected

        def permitted_attributes
          %w[content homepage meta_description meta_keywords parent_id path
             published_at slug template_id title]
        end

        def set_resources
          @pages = filtrate(
            current_site.pages.page(page_number).per(page_size)
          )
        end

        def set_resource
          resource_id = params.fetch(:id)

          @page = current_site.pages.find_by(id: resource_id)
        end

        def set_new_resource
          @page = current_site.pages.new(resource_params)
        end

        def resource_params
          params.require(resource_namespace).permit(permitted_attributes)
        end

        def resource_namespace
          controller_name.singularize.to_sym
        end
      end
    end
  end
end
