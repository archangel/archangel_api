# frozen_string_literal: true

module Archangel
  module Api
    module V1
      class RootsController < V1Controller
        def home
          json = {
            jsonapi: {
              version: "1.0"
            }
          }

          render_json json, status: :ok
        end
      end
    end
  end
end
