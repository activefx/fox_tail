# frozen_string_literal: true

class FoxTail::DropzoneComponent < FoxTail::BaseComponent
  DEFAULT_ICON = "cloud-arrow-up"

  renders_one :icon, lambda { |icon, attributes = {}|
    attributes[:class] = theme_css :icon, append: attributes[:class]
    attributes[:theme] = theme
    FoxTail::IconBaseComponent.new icon, attributes
  }

  renders_one :title, lambda { |text_or_attributes, attributes = {}, &block|
    attributes[:class] = theme_css :title, append: attributes[:class]

    if block
      attributes = text_or_attributes
      text_or_attributes = capture &block
    end

    content_tag :p, text_or_attributes, attributes
  }

  renders_one :helper_text, lambda { |text, attributes = {}|
    attributes[:class] = theme_css :helper_text, append: attributes[:class]
    content_tag :p, text, attributes
  }

  def before_render
    super

    with_icon DEFAULT_ICON, variant: :outline unless icon?
    with_title I18n.t("components.fox_tail.dropzone.title_html").html_safe unless title?
    html_attributes[:type] = :file
    html_attributes[:class] = theme_css
  end

  private

  def outer_container_attributes
    { class: classnames(theme.apply(:outer_container, self), html_class) }
  end

  def inner_container_attributes
    { class: theme.apply(:inner_container, self) }
  end
end
