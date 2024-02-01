# frozen_string_literal: true

class FoxTail::ToggleComponent < FoxTail::Base
  has_option :size, default: :normal
  has_option :color, default: :default

  renders_one :label, lambda { |text, options = {}|
    options[:class] = theme_css :label, append: options[:class]
    content_tag :span, text, options
  }

  def before_render
    super

    html_attributes[:type]
  end

  def call
    content_tag :label, container_attributes do
      concat content_tag(:input, nil, input_attributes)
      concat content_tag(:div, nil, toggle_attributes)
      concat label if label?
    end
  end

  private

  def container_attributes
    { class: theme_css(:container, append: html_class) }
  end

  def input_attributes
    html_attributes.merge type: :checkbox, class: theme_css(:root)
  end

  def toggle_attributes
    { class: theme_css(:toggle) }
  end
end
