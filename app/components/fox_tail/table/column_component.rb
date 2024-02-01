# frozen_string_literal: true

class FoxTail::Table::ColumnComponent < FoxTail::Base
  has_option :tag, default: :td
  has_option :highlight, default: :none
  has_option :hover, type: :boolean, default: false
  has_option :border, type: :boolean, default: true

  def even?
    position.is_a?(Numeric) && position.even?
  end

  def before_render
    super

    html_attributes[:class] = theme_css :root, append: html_class
  end

  def call
    content_tag tag, content, html_attributes
  end
end
