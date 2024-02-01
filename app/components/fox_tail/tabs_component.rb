# frozen_string_literal: true

class FoxTail::TabsComponent < FoxTail::Base
  has_option :variant, default: :default
  has_option :controlled, type: :boolean, default: false

  renders_many :tabs, lambda { |options = {}|
    options[:tabs_id] = tag_id
    options[:variant] = variant
    options[:controlled] = controlled?
    options[:theme] = theme
    FoxTail::Tabs::TabComponent.new options
  }

  renders_many :panels, lambda { |id, options = {}|
    options[:role] = :tabpanel
    options[:theme] = theme
    FoxTail::Tabs::PanelComponent.new id, options
  }

  def initialize(html_attributes = {})
    super(html_attributes)

    self.html_attributes[:id] ||= "tabs-#{SecureRandom.hex(4)}" if controlled?
  end

  def tag_id
    html_attributes[:id]
  end

  def render?
    tabs?
  end

  def before_render
    super

    html_attributes[:role] = :tablist
    html_attributes[:class] = theme_css :root, append: html_class
  end

  def call
    capture do
      concat render_tabs
      concat render_panels if panels?
    end
  end

  private

  def render_tabs
    content_tag :div, html_attributes do
      tabs.each { |tab| concat tab }
    end
  end

  def render_panels
    content_tag :div do
      panels.each { |panel| concat panel }
    end
  end
end
