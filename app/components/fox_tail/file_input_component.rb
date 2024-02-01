# frozen_string_literal: true

class FoxTail::FileInputComponent < FoxTail::InputBaseComponent
  def before_render
    super

    html_attributes[:class] = theme_css :root, append: html_class
    html_attributes[:type] = :file
  end

  def call
    tag :input, html_attributes
  end

  protected

  def can_read_only?
    false
  end
end
