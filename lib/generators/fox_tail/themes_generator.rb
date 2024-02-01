# frozen_string_literal: true

require 'rails/generators'

module FoxTail
  class ThemesGenerator < Rails::Generators::Base
    desc "Copy the default Fox Tail UI theme"

    source_root FoxTail.root.join("config").to_s

    def copy_theme
      copy_file "theme.yml", "config/theme.yml"
    end
  end
end
