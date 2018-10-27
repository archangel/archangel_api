# frozen_string_literal: true

module Archangel
  class V1Controller < ApiController
    include Brita
    include Archangel::Api::JsonApi::IncludableConcern
    include Archangel::Api::JsonApi::PaginatableConcern

    protected

    def render_not_found
      error = {
        status: 404,
        title: "Not Found",
        detail: "Not found"
      }

      render_error(error, status: :not_found)
    end

    def render_unprocessable_entity
      error = {
        status: 422,
        title: "Unprocessable Entity",
        detail: "Unprocessable entity"
      }

      render_error(error, status: :unprocessable_entity)
    end

    def render_error(error, options = {})
      errors = {
        errors: [error]
      }

      render_json(errors, options)
    end

    def render_json(object, options = {})
      attrib = { json: object }.merge(options)

      render attrib
    end
  end
end
