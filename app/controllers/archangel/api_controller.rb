# frozen_string_literal: true

module Archangel
  class ApiController < ActionController::API
    def current_site
      @current_site ||= Archangel::Site.current
    end
  end
end
