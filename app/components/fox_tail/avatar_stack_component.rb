# frozen_string_literal: true

class FoxTail::AvatarStackComponent < FoxTail::Base
  renders_many :avatars, lambda { |options = {}|
    options[:size] = size
    options[:rounded] = rounded
    options[:border] = true unless options.key? :border
    options[:class] = merge_theme_css %i[content avatar], append: options[:class]
    options[:theme] = theme
    FoxTail::AvatarComponent.new options
  }

  renders_one :counter, lambda { |text, options = {}|
    options.extract! :src, :icon
    url = options.delete :url
    options[:text] = text
    options[:size] = size
    options[:rounded] = rounded
    options[:border] = true unless options.key? :border
    options[:class] = merge_theme_css %i[content counter], append: options[:css]
    options[:theme] = theme

    if url.present?
      link_to url, class: theme_css("counter/link") do
        render FoxTail::AvatarComponent.new(options)
      end
    else
      FoxTail::AvatarComponent.new options
    end
  }

  has_option :size, default: :normal
  has_option :rounded, default: true, type: :boolean

  def render?
    avatars? || counter?
  end

  def before_render
    super

    html_attributes[:class] = theme_css :root, append: html_class
  end

  def call
    content_tag :div, html_attributes do
      avatars.each { |avatar| concat avatar }
      concat counter if counter?
    end
  end
end
