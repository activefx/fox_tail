# frozen_string_literal: true

class FoxTail::Table::HeaderComponent < FoxTail::Base
  renders_many :columns, lambda { |options = {}|
    options = options.merge self.options
    options[:theme] = theme
    options[:tag] = :th
    options[:scope] = :col
    FoxTail::Table::ColumnComponent.new options
  }

  has_option :highlight, default: :none
  has_option :hover, type: :boolean, default: false
  has_option :border, type: :boolean, default: true

  def before_render
    super

    html_attributes[:class] = theme_css :root, append: html_class
  end

  def render?
    columns?
  end

  def call
    content_tag :tr, html_attributes do
      columns.each { |column| concat column }
    end
  end
end
