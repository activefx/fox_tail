# frozen_string_literal: true

require "fox_tail/config"

module FoxTail
  class Engine < Rails::Engine
    isolate_namespace FoxTail

    config.fox_tail = Config.current
    config.eager_load_paths = %W[#{root}/app/components #{root}/app/helpers]

    initializer "tailwind_theme.include_gem_load_path" do
      ActiveSupport.on_load(:tailwind_theme) do
        ::TailwindTheme.load_paths << FoxTail.root.join("config")
        ::TailwindTheme.missing_classname = false
      end
    end
  end
end