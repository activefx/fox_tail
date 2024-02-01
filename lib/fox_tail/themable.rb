# frozen_string_literal: true

module FoxTail
  # Themed View Component concern
  module Themable
    extend ActiveSupport::Concern

    included do
      reserved_options.append :theme if respond_to? :reserved_options
    end

    def theme
      @theme ||= view_context.try(:theme)
    end

    def theme_css(path_or_options = {}, options = {})
      if path_or_options.is_a?(Hash)
        options = path_or_options
        path_or_options = :root
      end

      theme_options = extract_theme_options! options
      paths = theme_paths path_or_options
      theme.merge_css paths, theme_options
    end

    def merge_theme_css(paths, options = {})
      theme_options = extract_theme_options! options
      paths = paths.each_with_object([]) { |path, results| results.concat theme_paths(path) }
      theme.merge_css paths, theme_options
    end

    private

    def extract_theme!(options)
      theme = options.delete :theme

      @theme = if theme.is_a?(Hash)
                 TailwindTheme::Theme.new theme
               elsif theme.is_a?(TailwindTheme::Theme)
                 theme
               else
                 view_context.try :theme, theme
               end
    end

    def extract_theme_options!(options)
      theme_options = options.extract! :prepend, :append, :attributes, :raise
      theme_options[:object] = self
      theme_options
    end

    def theme_paths(path)
      scopes = self.class.theme_scopes include_ancestors: options.fetch(:include_ancestors, true)
      scopes.map { |scope| [scope, path].flatten }
    end

    def theme_path(namespace, path, scope)
      scope = "#{scope}/#{namespace.presence}" if namespace.present?
      [scope, path]
    end

    class_methods do
      def theme_scope
        theme_scope_for self
      end

      def theme_scopes(include_ancestors: true)
        return [theme_scope] unless include_ancestors

        ancestors.select { |klass| klass.is_a? Class }.reverse.map { |klass| theme_scope_for klass }
      end

      private

      def theme_scope_for(klass)
        "components.#{klass.name.underscore.gsub("_component", "")}"
      end
    end
  end
end
