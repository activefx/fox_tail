# frozen_string_literal: true

class FoxTail::BadgeComponent < FoxTail::Base
  renders_one :icon, lambda { |icon, options = {}|
    options[:variant] ||= :mini
    options[:"aria-hidden"] = true
    options[:class] = theme_css :icon
    options[:theme] = theme
    FoxTail::IconBaseComponent.new icon, options
  }

  has_option :url
  has_option :size, default: :normal
  has_option :color, default: :default
  has_option :pill, default: false, type: :boolean
  has_option :icon_only, default: false, type: :boolean
  has_option :border, default: false, type: :boolean

  def tag_name
    url? ? :a : :span
  end

  def before_render
    super

    html_attributes[:href] = url if url?
    html_attributes[:class] = theme_css :root, append: html_class
  end

  def call
    content_tag tag_name, html_attributes do
      concat icon if icon?
      concat content_tag(:span, content, class: theme_css(:content)) if content?
    end
  end
end
