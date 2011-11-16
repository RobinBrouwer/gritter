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
    Gritter.install_locales
    @initialized = true
  end
  
  def self.install_locales
    orig_lang = File.join(File.dirname(__FILE__), 'gritter', 'assets', 'gflash.en.yml')
    dest_lang = File.join(Rails.root, 'config', 'locales', 'gflash.en.yml')
    unless File.exists?(dest_lang)
      puts "Copying language file to #{dest_lang}..."
      FileUtils.cp_r orig_lang, dest_lang
    end
  end
end

if defined?(Rails::Railtie)
  require 'gritter/railtie'
end
