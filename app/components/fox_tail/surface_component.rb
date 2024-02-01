# frozen_string_literal: true

class FoxTail::SurfaceComponent < FoxTail::Base
  has_option :border, type: :boolean, default: true
  has_option :tag_name, default: :div
  has_option :hover, type: :boolean, default: false

  def before_render
    super

    html_attributes[:class] = theme_css :root, append: html_class
  end

  def call
    content_tag tag_name, content, html_attributes
  end
end
