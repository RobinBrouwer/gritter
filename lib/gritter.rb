require 'gritter/helpers'
require 'gritter/gflash'
require 'gritter/engine'
require 'fileutils'

module Gritter
  @rails_flash_fallback = false
  
  def self.rails_flash_fallback
    @rails_flash_fallback
  end
  def self.rails_flash_fallback=(val)
    @rails_flash_fallback = val
  end
  
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
