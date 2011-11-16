require 'gritter/helpers'
require 'gritter/gflash'
require 'gritter/engine'
require 'fileutils'

module Gritter
  def self.initialize
    return if @initialized
    raise "ActionController is not available yet." unless defined?(ActionController)
    ActionController::Base.send(:helper, Gritter::Helpers)
    ActionController::Base.send(:include, Gritter::Gflash)
    @initialized = true
  end
end

if defined?(Rails::Railtie)
  require 'gritter/railtie'
end
