# frozen_string_literal: true

module Archangel
  module Api
    module V1
      class SitesController < V1Controller
        before_action :set_resource, only: %i[show]

        def show
          render_json @site
        end

        protected

        def set_resource
          @site = current_site
        end
      end
    end
  end
end
