# frozen_string_literal: true

class FoxTail::IconButtonComponent < FoxTail::ButtonBaseComponent
  renders_many :icons, lambda { |icon, options = {}|
    options[:class] = theme_css :icon, append: options[:class]
    options[:theme] = theme
    FoxTail::IconBaseComponent.new icon, options
  }

  def initialize(icon_or_attributes = {}, html_attributes = {})
    if icon_or_attributes.is_a? Hash
      html_attributes = icon_or_attributes
      icon_or_attributes = nil
    end

    super(html_attributes)
    @icon_attributes = icon_or_attributes
  end

  def before_render
    super

    with_icon @icon_attributes if @icon_attributes.present?
  end

  def call
    super do
      icons.each { |icon| concat icon }
      concat indicator if indicator?

      if content? || i18n_content.present?
        concat content_tag(:span, retrieve_content, class: theme_css(:content))
      end
    end
  end
end
