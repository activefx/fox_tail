# frozen_string_literal: true

class FoxTail::DialogComponent < FoxTail::SurfaceComponent
  renders_one :header, lambda { |options = {}, &block|
    options[:class] = theme_css :header, append: options[:class]
    content_tag :div, options, &block
  }

  renders_one :body, lambda { |options = {}, &block|
    options[:class] = theme_css :body, append: options[:class]
    content_tag :div, options, &block
  }

  renders_one :footer, lambda { |options = {}, &block|
    options[:class] = theme_css :footer, append: options[:class]
    content_tag :div, options, &block
  }

  def initialize(html_attributes = {})
    html_attributes[:border] = false unless html_attributes.key? :border
    super(html_attributes)
  end

  def hover?
    false
  end

  def tag_name
    :div
  end
end
