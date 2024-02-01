# frozen_string_literal: true

class FoxTail::TimelineComponent < FoxTail::Base
  renders_many :entries, lambda { |options = {}|
    options[:vertical] = vertical?
    options[:theme] = theme
    FoxTail::Timeline::EntryComponent.new options
  }

  has_option :vertical, type: :boolean, default: true

  def render?
    entries?
  end

  def before_render
    super

    html_attributes[:class] = theme_css :root, append: html_class
  end

  def call
    content_tag :ol, html_attributes do
      entries.each { |entry| concat entry }
    end
  end
end
