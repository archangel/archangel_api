# frozen_string_literal: true

module Archangel
  module Api
    module V1
      class ErrorsController < V1Controller
        def resource_not_found
          error_translation_scope = %i[api errors resource_not_found]
          error = {
            status: 404,
            title: Archangel.t(:title, scope: error_translation_scope),
            detail: Archangel.t(:detail, scope: error_translation_scope)
          }

          render_error [error], status: :not_found
        end
      end
    end
  end
end
