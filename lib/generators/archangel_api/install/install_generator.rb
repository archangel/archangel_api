# frozen_string_literal: true

module ArchangelApi
  module Generators
    class InstallGenerator < ::Rails::Generators::Base
      class_option :auto_run_migrations, type: :boolean, default: false

      def add_javascripts
        %w[auth backend frontend].each do |section|
          append_file "vendor/assets/javascripts/archangel/#{section}.js",
                      "//= require archangel/#{section}/archangel_api\n"
        end
      end

      def add_stylesheets
        %w[auth backend frontend].each do |section|
          inject_into_file "vendor/assets/stylesheets/archangel/#{section}.css",
                           "*= require archangel/#{section}/archangel_api\n ",
                           before: %r{\*/},
                           verbose: true
        end
      end

      def add_migrations
        run "bundle exec rails railties:install:migrations FROM=archangel_api"
      end

      def run_migrations
        migration_message = "Would you like to run the migrations now? [Y/n]"

        run_migrations = options[:auto_run_migrations] || ["", "y", "Y"]
                         .include?(ask(migration_message))

        if run_migrations
          run "bundle exec rails db:migrate"
        else
          puts "Skipping `rails db:migrate`, don't forget to run it!"
        end
      end
    end
  end
end
