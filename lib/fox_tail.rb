require "active_support/dependencies/autoload"
require "tailwind_theme-rails"

require "fox_tail/version"
require "fox_tail/errors"
require "fox_tail/engine"

module FoxTail
  extend ActiveSupport::Autoload

  autoload :Config
  autoload :Translator
  autoload :StimulusController

  # Concerns
  autoload :Configurable
  autoload :Controllable
  autoload :Formable
  autoload :Placeholderable
  autoload :Themable

  autoload :Base


  def self.root
    Pathname.new File.expand_path("..", __dir__)
  end
end
