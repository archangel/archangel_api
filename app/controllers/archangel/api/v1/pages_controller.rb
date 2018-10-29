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
          options = {
            is_collection: true,
            links: resource_listing_links,
            meta: resource_listing_meta
          }

          render_json serializer.new(@pages, options).serialized_json
        end

        def show
          render_not_found && return if @page.blank?

          options = {
            is_collection: false
          }

          render_json serializer.new(@page, options).serialized_json
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

        def serializer
          Archangel::Api::V1::PageSerializer
        end

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

        def resource_listing_meta
          {
            current_count: 12,
            total_count: 500,
            current_page: 1,
            first_page: 1,
            previous_page: nil,
            next_page: 2,
            last_page: 40
          }
        end

        def resource_listing_links
          {
            self: "self url",
            first_page: "first page url",
            previous_page: "prev page url",
            next_page: "next page url",
            last_page: "last page url",
            home_page: "homepage url"
          }
        end
      end
    end
  end
end
