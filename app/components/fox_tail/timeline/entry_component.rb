# frozen_string_literal: true

class FoxTail::Timeline::EntryComponent < FoxTail::Base
  renders_one :visual, types: {
    dot: {
      as: :dot_indicator,
      renders: lambda { |options = {}|
        options[:color] ||= :neutral
        options[:class] = merge_theme_css %i[visual visual/dot], append: options[:class]
        options[:theme] = theme
        FoxTail::DotIndicatorComponent.new options
      }
    },
    icon: {
      as: :icon,
      renders: lambda { |icon_or_options = {}, options = {}|
        if icon_or_options.is_a? Hash
          options = icon_or_options
          icon_or_options = "calendar"
        end

        render_icon(options) { |attributes| render FoxTail::IconBaseComponent.new(icon_or_options, attributes) }
      }
    },
    svg: {
      as: :svg,
      renders: lambda { |path, options = {}|
        render_icon(options) { |attributes| render FoxTail::InlineSvgComponent.new(path, attributes) }
      }
    },
    image: {
      as: :image,
      renders: lambda { |source, options = {}|
        container_classes = merge_theme_css %i[visual visual/container], append: options.delete(:class)
        options[:class] = theme_css "visual/image"

        content_tag :span, class: container_classes do
          image_tag source, options
        end
      }
    }
  }

  has_option :vertical, type: :boolean, default: true

  def render?
    content?
  end

  def before_render
    super

    with_dot_indicator unless visual?
    html_attributes[:class] = theme_css :root, append: html_class
  end

  private

  def render_icon(options, &block)
    display_options = options.extract! :color
    display_options[:color] ||= :default
    container_classes = merge_theme_css %i[visual visual/container], append: options.delete(:class)
    options[:class] = theme_css "visual/icon", attributes: display_options
    options[:theme] = theme

    content_tag :span, class: container_classes do
      block.call options, display_options
    end
  end
end
