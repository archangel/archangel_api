# frozen_string_literal: true

module Archangel
  module Api
    module JsonApi
      module PaginatableConcern
        extend ActiveSupport::Concern

        module ClassMethods
          attr_reader :_paginatable_opts

          private

          ##
          # JSON API pagination configurations for controllers
          #
          # Usage
          #   paginatable(number: 2) # Page 2 of results. Default 1
          #   paginatable(size: 24)  # 24 records in the response. Default 12
          #   paginatable(number: 2, size: 24)
          #
          # Example
          #   class MyController < ActionController::API
          #     include Archangel::Api::JsonApi::PaginatableConcern
          #     paginatable(size: 50)
          #   end
          #
          def paginatable(opts = {})
            @_paginatable_opts = opts
          end
        end

        def page_size
          opts = build_paginatable_opts

          pagination_params.fetch(:size, opts[:size])
        end

        def page_number
          opts = build_paginatable_opts

          pagination_params.fetch(:number, opts[:number])
        end

        private

        def build_paginatable_opts
          class_opts = self.class._paginatable_opts

          opts = class_opts.present? ? class_opts : {}

          default_options.merge(opts)
        end

        def default_options
          {
            number: 1,
            size: 24
          }
        end

        def pagination_params
          params.fetch(:page, {}).permit(:number, :size)
        end
      end
    end
  end
end
