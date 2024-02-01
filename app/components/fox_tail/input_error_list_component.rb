# frozen_string_literal: true

class FoxTail::InputErrorListComponent < FoxTail::Base
  include FoxTail::Formable

  has_option :aliases

  renders_many :messages, lambda { |text_or_attributes = {}, attributes = {}, &block|
    if block
      attributes = text_or_attributes
      text_or_attributes = capture(self, &block)
    end

    attributes[:class] = theme_css(:message, append: attributes[:class])
    content_tag :li, text_or_attributes, attributes
  }

  def render?
    messages? || error_messages.present?
  end

  def before_render
    super

    html_attributes[:class] = theme_css(:root, append: html_class)
    error_messages.each { |msg| with_message msg } unless messages?
  end

  def call
    content_tag :ul, html_attributes do
      messages.each { |msg| concat msg }
    end
  end

  private

  def error_messages
    @error_messages ||= object? && method_name? ? retrieve_errors : []
  end

  def retrieve_errors
    object = convert_to_model self.object
    attributes = (Array(method_name) + Array(aliases)).compact_blank.uniq
    messages = attributes.each_with_object([]) do |attr, results|
      results.concat object.errors[attr] if object.errors[attr].present?
    end

    messages.uniq
  end
end
