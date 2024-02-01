require "active_support/dependencies/autoload"
require "tailwind_theme-rails"

require "fox_tail/version"
require "fox_tail/errors"
require "fox_tail/engine"

module FoxTail
  extend ActiveSupport::Autoload

  autoload :Config
  autoload :Base
  autoload :Translator
  autoload :StimulusController

  def self.root
    Pathname.new File.expand_path("..", __dir__)
  end
end
