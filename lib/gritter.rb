require 'gritter/helpers'
require 'gritter/gflash'

module Gritter
  def self.install_gritter
    require 'fileutils'
    orig_javascripts = File.join(File.dirname(__FILE__), 'gritter', 'assets', 'javascripts')
    orig_stylesheets = File.join(File.dirname(__FILE__), 'gritter', 'assets', 'stylesheets')
    orig_images = File.join(File.dirname(__FILE__), 'gritter', 'assets', 'images')
    dest_javascripts = File.join(RAILS_ROOT, 'public', 'javascripts', 'gritter')
    dest_stylesheets = File.join(RAILS_ROOT, 'public', 'stylesheets', 'gritter')
    dest_images = File.join(RAILS_ROOT, 'public', 'images', 'gritter')
    
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
        puts "Successfully installed gritter."
      rescue
        puts "ERROR: Problem installing gritter. Please copy the files manually."
      end
    end
  end
end

if defined?(Rails) && defined?(ActionController)
  ActionController::Base.send(:helper, Gritter::Helpers)
  ActionController::Base.send(:include, Gritter::Gflash)
  Gritter.install_gritter
end