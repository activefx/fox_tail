# frozen_string_literal: true

class FoxTail::WrappedComponent < FoxTail::Base
  attr_reader :block

  def initialize(html_attributes = {}, &block)
    super(html_attributes)
    @block = block
  end

  def with_html_class(classnames = nil, &block)
    super classnames, &block
  end

  def block?
    !!block
  end

  def before_render
    super

    html_attributes[:class] = theme_css :root, append: html_class
  end

  def render?
    block? || content?
  end

  def call
    Rails.logger.info "Test: #{block?} - #{html_class}"
    block? ? capture(self, &block) : content
  end
end
