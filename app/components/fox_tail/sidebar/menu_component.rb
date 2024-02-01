# frozen_string_literal: true

class FoxTail::Sidebar::MenuComponent < FoxTail::Base
  renders_many :items, lambda { |options = {}|
    options[:level] = level
    options[:theme] = theme
    FoxTail::Sidebar::MenuItemComponent.new options
  }

  # renders_one :menu, lambda { |options = {}|
  #   options[:level] = level + 1
  #   options[:theme] = theme
  #   FoxTail::Sidebar::MenuItemComponent.new options
  # }

  has_option :level, default: 0

  def render?
    items?
  end

  def before_render
    super

    html_attributes[:class] = theme_css :root, append: html_class
  end

  def call
    content_tag :ul, html_attributes do
      items.each { |item| concat item }
    end
  end
end
