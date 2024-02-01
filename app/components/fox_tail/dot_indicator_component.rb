# frozen_string_literal: true

class FoxTail::DotIndicatorComponent < FoxTail::Base
  has_option :color, default: :default
  has_option :animated, default: false, type: :boolean
  has_option :size, default: :normal

  def call
    animated? ? render_animated_dot : render_dot
  end

  private

  def render_dot
    attributes = html_attributes.merge(class: merge_theme_css(%i[root dot], append: html_class))
    content_tag :span, nil, attributes
  end

  def render_animated_dot
    content_tag :span, html_attributes.merge(class: merge_theme_css(%i[root container], append: html_class)) do
      concat content_tag(:span, nil, class: merge_theme_css([:root, :dot, "dot/animation"]))
      concat content_tag(:span, nil, class: merge_theme_css(%i[root dot]))
    end
  end
end
