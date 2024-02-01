# frozen_string_literal: true

class FoxTail::ListGroupComponent < FoxTail::BaseComponent
  renders_many :items, lambda { |options = {}|
    options[:flush] = flush?
    options[:theme] = theme
    FoxTail::ListGroup::ItemComponent.new options
  }

  has_option :flush, type: :boolean, default: false

  def render?
    items?
  end

  def before_render
    super

    html_attributes[:class] = theme_css(:root, append: html_class)
  end

  def call
    content_tag :div, html_attributes do
      items.each { |item| concat item }
    end
  end
end
