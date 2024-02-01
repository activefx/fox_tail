# frozen_string_literal: true

class FoxTail::Stepper::StepComponent < FoxTail::Base
  DEFAULT_COMPLETED_ICON = "check"
  DEFAULT_VERTICAL_CURRENT_ICON = "arrow-right"

  renders_one :visual, types: {
    icon: {
      as: :icon,
      renders: lambda { |icon, options = {}|
        options[:class] = merge_theme_css %i[visual visual/icon], append: options[:class]
        options[:theme] = theme
        FoxTail::IconBaseComponent.new icon, options
      }
    },
    svg: {
      as: :svg,
      renders: lambda { |path, options = {}|
        options[:class] = merge_theme_css %i[visual visual/svg], append: options[:class]
        options[:theme] = theme
        FoxTail::InlineSvgComponent.new path, options
      }
    },
    image: {
      as: :image,
      renders: lambda { |source, options = {}|
        options[:class] = merge_theme_css %i[visual visual/image], append: options[:class]
        image_tag source, options
      }
    }
  }

  has_option :variant, default: :default
  has_option :state, default: :pending
  has_option :index, default: 0

  def before_render
    super

    initialize_visual
    html_attributes[:class] = theme_css :root, append: html_class
  end

  private

  def initialize_visual
    return if visual?

    if state == :completed && (content? || variant == :vertical)
      with_icon DEFAULT_COMPLETED_ICON
    elsif state == :current && variant == :vertical
      with_icon DEFAULT_VERTICAL_CURRENT_ICON
    end
  end
end
