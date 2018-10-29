# frozen_string_literal: true

module Archangel
  module Api
    module V1
      class SitesController < V1Controller
        before_action :set_resource, only: %i[show]

        def show
          options = {
            is_collection: false,
            links: {},
            meta: {}
          }

          render_json serializer.new(@site, options).serialized_json
        end

        protected

        def serializer
          Archangel::Api::V1::SiteSerializer
        end

        def set_resource
          @site = current_site
        end
      end
    end
  end
end
