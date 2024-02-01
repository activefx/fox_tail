# frozen_string_literal: true

class FoxTail::HelperTextComponent < FoxTail::Base
  include FoxTail::Formable

  has_option :state

  def render?
    content.present? || content_translator.translate.present?
  end

  def before_render
    super

    html_attributes[:class] = theme_css :root, append: html_class
  end

  def call
    content_tag :p, retrieve_content, html_attributes
  end

  private

  def retrieve_content
    return content if content?
    return nil unless object_name? && method_name?

    content_translator.translate
  end

  def content_translator
    translator scope: "helpers.help_text"
  end
end
