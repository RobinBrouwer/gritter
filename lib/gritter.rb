require 'gritter/helpers'
require 'gritter/gflash'

module Gritter
  def self.initialize
    return if @initialized
    raise "ActionController is not available yet." unless defined?(ActionController)
    ActionController::Base.send(:helper, Gritter::Helpers)
    ActionController::Base.send(:include, Gritter::Gflash)
    Gritter.install_gritter
    @initialized = true
  end
  
  def self.install_gritter
    require 'fileutils'
    orig_javascripts = File.join(File.dirname(__FILE__), 'gritter', 'assets', 'javascripts')
    orig_stylesheets = File.join(File.dirname(__FILE__), 'gritter', 'assets', 'stylesheets')
    orig_images = File.join(File.dirname(__FILE__), 'gritter', 'assets', 'images')
    orig_lang = File.join(File.dirname(__FILE__), 'gritter', 'assets', 'gflash.en.yml')
    dest_javascripts = File.join(Rails.root, 'public', 'javascripts', 'gritter')
    dest_stylesheets = File.join(Rails.root, 'public', 'stylesheets', 'gritter')
    dest_images = File.join(Rails.root, 'public', 'images', 'gritter')
    dest_lang = File.join(Rails.root, 'config', 'locales', 'gflash.en.yml')
    
    gritter = File.join(dest_javascripts, 'jquery.gritter.min.js')

    unless File.exists?(gritter) && FileUtils.identical?(File.join(orig_javascripts, 'jquery.gritter.min.js'), gritter)
      begin
        puts "Creating directory #{dest_javascripts}..."
        FileUtils.mkdir_p dest_javascripts
        puts "Creating directory #{dest_stylesheets}..."
        FileUtils.mkdir_p dest_stylesheets
        puts "Creating directory #{dest_images}..."
        FileUtils.mkdir_p dest_images
        puts "Copying gritter to #{dest_javascripts}..."
        FileUtils.cp_r "#{orig_javascripts}/.", dest_javascripts
        puts "Copying gritter to #{dest_stylesheets}..."
        FileUtils.cp_r "#{orig_stylesheets}/.", dest_stylesheets
        puts "Copying gritter to #{dest_images}..."
        FileUtils.cp_r "#{orig_images}/.", dest_images
        puts "Copying language file to #{dest_lang}..."
        FileUtils.cp_r orig_lang, dest_lang
        puts "Successfully installed gritter."
      rescue
        puts "ERROR: Problem installing gritter. Please copy the files manually."
      end
    end
  end
end

if defined?(Rails::Railtie)
  require 'gritter/railtie'
end