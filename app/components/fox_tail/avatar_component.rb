# frozen_string_literal: true

class FoxTail::AvatarComponent < FoxTail::Base
  renders_one :dot, lambda { |options = {}|
    dot_options = options.extract!(:position).reverse_merge(position: :top_right)
    options[:class] = theme_css :dot, attributes: dot_options, append: options[:class]
    options[:theme] = theme
    FoxTail::DotIndicatorComponent.new options
  }

  has_option :src
  has_option :icon
  has_option :text
  has_option :size, default: :normal
  has_option :rounded, type: :boolean, default: false

  has_option :border, default: false do |value|
    if value.is_a?(TrueClass)
      :default
    elsif !value
      :none
    else
      value.to_sym
    end
  end

  def border?
    border != :none
  end

  def call
    if dot?
      content_tag :div, class: theme_css("dot/container") do
        concat dot
        concat render_visual
      end
    else
      render_visual
    end
  end

  def variant
    if src?
      :image
    elsif icon?
      :icon
    elsif text?
      :text
    else
      :blank
    end
  end

  def icon_name
    icon.is_a?(Hash) ? icon[:name] : icon
  end

  def icon_variant
    icon.is_a?(Hash) ? icon[:variant] : :solid
  end

  private

  def root_classes
    theme_css :root, append: html_class
  end

  def render_visual
    if src?
      render_image
    elsif icon?
      render_icon
    elsif text?
      render_text
    else
      render_blank
    end
  end

  def render_image
    image_tag src, html_attributes.merge(class: root_classes)
  end

  def render_icon
    icon_component = FoxTail::IconBaseComponent.new(
      icon_name,
      variant: icon_variant,
      class: theme_css(:icon),
      theme: theme
    )

    content_tag :div, html_attributes.except(:alt).merge(class: root_classes) do
      concat render(icon_component)

      concat content_tag(:span, html_attributes[:alt], class: theme_css(:label)) if html_attributes[:alt].present?
    end
  end

  def render_text
    content_tag :div, html_attributes.except(:alt).merge(class: root_classes) do
      concat content_tag(:span, text, class: theme_css(:text))

      concat content_tag(:span, html_attributes[:alt], class: theme_css(:label)) if html_attributes[:alt].present?
    end
  end

  def render_blank
    content_tag :div, html_attributes.except(:alt).merge(class: root_classes) do
      content_tag(:span, html_attributes[:alt], class: theme_css(:label)) if html_attributes[:alt].present?
    end
  end
end
