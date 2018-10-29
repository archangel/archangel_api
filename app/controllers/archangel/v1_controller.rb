# frozen_string_literal: true

module Archangel
  class V1Controller < ApiController
    include Brita
    include Archangel::Api::JsonApi::IncludableConcern
    include Archangel::Api::JsonApi::PaginatableConcern

    protected

    def render_not_found
      error_translation_scope = %i[api errors not_found]
      error = {
        status: 404,
        title: Archangel.t(:title, scope: error_translation_scope),
        detail: Archangel.t(:detail, scope: error_translation_scope)
      }

      render_error([error], status: :not_found)
    end

    def render_unprocessable_entity
      error_translation_scope = %i[api errors unprocessable_entity]
      error = {
        status: 422,
        title: Archangel.t(:title, scope: error_translation_scope),
        detail: Archangel.t(:detail, scope: error_translation_scope)
      }

      render_error([error], status: :unprocessable_entity)
    end

    def render_error(errors, options = {})
      errors = {
        errors: errors
      }

      render_json(errors, options)
    end

    def render_json(object, options = {})
      attrib = { json: object }.merge(options)

      render attrib
    end
  end
end
