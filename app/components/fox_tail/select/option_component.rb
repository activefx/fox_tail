# frozen_string_literal: true

class FoxTail::Select::OptionComponent < FoxTail::Base
  attr_reader :value

  has_option :selected, type: :boolean, default: false

  def initialize(value, html_attributes = {})
    @value = value
    super(html_attributes)
  end

  def before_render
    super

    html_attributes[:value] = value
    html_attributes[:selected] = :selected if selected?
  end

  def call
    content_tag :option, content? ? content : value.to_s.humanize, html_attributes
  end
end
