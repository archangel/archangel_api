# frozen_string_literal: true

module Archangel
  module Api
    module V1
      module Collections
        class EntriesController < V1Controller
          paginatable(size: 12)

          sort_on :available_at, internal_name: :order_on_available_at,
                                 type: :scope,
                                 scope_params: [:direction]
          sort_on :id, internal_name: :order_on_id,
                       type: :scope,
                       scope_params: [:direction]
          sort_on :position, internal_name: :order_on_position,
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

            render_json serializer.new(@entries, options).serialized_json
          end

          def show
            render_not_found && return if @entry.blank?

            options = {
              is_collection: false
            }

            render_json serializer.new(@entry, options).serialized_json
          end

          def create
            if @entry.save
              render_json(@entry, status: :created)
            else
              render_error(@entry.errors, status: :unprocessable_entity)
            end
          end

          def update
            if @entry.update(resource_params)
              render_json(@entry, status: :ok)
            else
              render_error(@entry.errors, status: :unprocessable_entity)
            end
          end

          def destroy
            @entry.destroy

            head :no_content
          end

          protected

          def serializer
            Archangel::Api::V1::Collections::EntrySerializer
          end

          def permitted_attributes
            %w[content homepage meta_description meta_keywords parent_id path
               published_at slug template_id title]
          end

          def set_resources
            @entries = filtrate(
              current_site.entries.page(page_number).per(page_size)
            )
          end

          def set_resource
            resource_id = params.fetch(:id)

            @entry = current_site.entries.find_by(id: resource_id)
          end

          def set_new_resource
            @entry = current_site.entries.new(resource_params)
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
              collection: "collection url"
            }
          end
        end
      end
    end
  end
end
