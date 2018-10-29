# frozen_string_literal: true

module Archangel
  module Api
    module V1
      class CollectionsController < V1Controller
        paginatable(size: 12)

        sort_on :id, internal_name: :order_on_id,
                     type: :scope,
                     scope_params: [:direction]
        sort_on :name, internal_name: :order_on_name,
                       type: :scope,
                       scope_params: [:direction]
        sort_on :slug, internal_name: :order_on_slug,
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

          render_json serializer.new(@collections, options).serialized_json
        end

        def show
          render_not_found && return if @collection.blank?

          options = {
            is_collection: false
          }

          render_json serializer.new(@collection, options).serialized_json
        end

        def create
          if @collection.save
            render_json(@collection, status: :created)
          else
            render_error(@collection.errors, status: :unprocessable_entity)
          end
        end

        def update
          if @collection.update(resource_params)
            render_json(@collection, status: :ok)
          else
            render_error(@collection.errors, status: :unprocessable_entity)
          end
        end

        def destroy
          @collection.destroy

          head :no_content
        end

        protected

        def serializer
          Archangel::Api::V1::CollectionSerializer
        end

        def permitted_attributes
          %w[content homepage meta_description meta_keywords parent_id path
             published_at slug template_id title]
        end

        def set_resources
          @collections = filtrate(
            current_site.collections.page(page_number).per(page_size)
          )
        end

        def set_resource
          resource_id = params.fetch(:id)

          @collection = current_site.collections.find_by(slug: resource_id)
        end

        def set_new_resource
          @collection = current_site.collections.new(resource_params)
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
            entries: "entries url"
          }
        end
      end
    end
  end
end
