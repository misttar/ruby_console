# encoding: utf-8
require 'rubygems'
Gem::Specification.class_eval { def self.warn( args ); end }
require 'pry'

module Appium; end unless defined? Appium

def define_reload
  Pry.send(:define_singleton_method, :reload) do
    files = load_appium_txt file: Dir.pwd + '/appium.txt'
    files.each do |file|
      # If a page obj is deleted then load will error.
      begin
        load file
      rescue # LoadError: cannot load such file
      end
    end
  end
  nil
end

module Appium::Console
  require 'appium_lib'
  AwesomePrint.pry!
  to_require = load_appium_txt file: Dir.pwd + '/appium.txt', verbose: true

  start = File.expand_path '../start.rb', __FILE__
  cmd = ['-r', start]

  if to_require && !to_require.empty?
    define_reload
    load_files = to_require.map { |f| %(require "#{f}";) }.join "\n"
    cmd += [ '-e', load_files ]
  end

  $stdout.puts "pry #{cmd.join(' ')}"
  Pry::CLI.parse_options cmd
end # module Appium::Console