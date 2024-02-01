# frozen_string_literal: true

class FoxTail::RadioButtonComponent < FoxTail::BaseComponent
  has_option :color, default: :default
  has_option :size, default: :normal

  def before_render
    super

    html_attributes[:type] = :radio
    html_attributes[:class] = theme_css :root, append: html_class
  end

  def call
    tag :input, html_attributes
  end
end
