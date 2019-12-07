# frozen_string_literal: true

require 'active_support/configurable'

module SolidusWishlist
  class Config
    include ActiveSupport::Configurable

    config_accessor :use_deface, instance_accessor: false do
      true
    end

    def self.without_deface!
      self.use_deface = false
    end
  end
end
