# frozen_string_literal: true

module Archangel
  module Api
    module JsonApi
      module IncludableConcern
        extend ActiveSupport::Concern

        module ClassMethods
          attr_reader :_includable_opts

          private

          ##
          # JSON API include configurations for controllers
          #
          # Usage
          #   includable(accepted: %w[foo bar]) # Related resources. Default []
          #   includable(default: "foo") # Related resource to include by default.
          #
          # Example
          #   class MyController < ActionController::API
          #     include JsonApi::IncludableConcern
          #     includable(accepted: %w[foo bar])
          #   end
          #
          def includable(opts = {})
            @_includable_opts = opts
          end
        end

        def options_include
          requested_options
        end

        def query_includes
          opts = build_includable_opts

          opts.fetch(:accepted, []).each_with_object({}) do |inc, includes|
            inc_split = inc.to_s.split(".")
            key = inc_split[0]
            value = inc_split[1]

            includes[key] = [] unless includes.key?(key)

            includes[key] += [value] if value.present?
          end
        end

        private

        def requested_options
          includes = include_params

          return [] if includes.blank?

          opts = build_includable_opts

          includes.to_s.split(",")
                  .select { |inc| opts.fetch(:accepted, []).include?(inc) }
                  .map(&:to_sym)
        end

        def build_includable_opts
          class_opts = self.class._includable_opts

          opts = class_opts.present? ? class_opts : {}

          default_options.merge(opts)
        end

        def default_options
          {
            accepted: [],
            default: nil
          }
        end

        def include_params
          opts = build_includable_opts

          params.fetch(:include, opts[:default])
        end
      end
    end
  end
end
