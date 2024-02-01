# frozen_string_literal: true

class FoxTail::Accordion::ItemComponent < FoxTail::Base
  attr_reader :id, :title

  renders_one :icon, types: {
    icon: {
      renders: lambda { |icon, options = {}|
        options[:class] = theme_css :icon, append: options[:class]
        options[:variant] ||= :mini
        options[:theme] = theme
        FoxTail::IconBaseComponent.new icon, options
      },
      as: :icon
    },
    svg: {
      renders: lambda { |path, attributes = {}|
        attributes[:class] = theme_css :icon, append: attributes[:class]
        FoxTail::InlineSvgComponent.new path, attributes
      },
      as: :svg_icon
    },
    image: {
      renders: lambda { |path, attributes = {}|
        attributes[:class] = theme_css :icon, append: attributes[:class]
        image_tag path, attributes
      },
      as: :image_icon
    }
  }


  renders_one :arrow, types: {
    icon: {
      renders: lambda { |options = {}|
        icon = options.delete(:icon) || :chevron_down
        icon_options = options.extract!(:rotate).reverse_merge(rotate: true)
        options[:class] = theme_css :arrow, attributes: icon_options, append: options[:class]
        options[:theme] = theme
        FoxTail::IconBaseComponent.new icon, options
      },
      as: :arrow
    },
    svg: {
      renders: lambda { |path, options = {}|
        svg_options = options.extract!(:rotate).reverse_merge(rotate: true)
        options[:class] = theme_css :arrow, attributes: svg_options, append: options[:class]
        FoxTail::InlineSvgComponent.new path, options
      },
      as: :svg_arrow
    },
    image: {
      renders: lambda { |path, options = {}|
        img_options = options.extract!(:rotate).reverse_merge(rotate: true)
        options[:class] = theme_css :arrow, attributes: img_options, append: options[:class]
        image_tag path, options
      },
      as: :image_arrow
    }
  }

  has_option :position, default: :middle
  has_option :flush, default: false, type: :boolean
  has_option :open, default: false, type: :boolean
  has_option :header_tag, default: :h2

  def initialize(id, title, html_attributes = {})
    @id = id
    @title = title
    super(html_attributes)
  end

  def body_id
    :"#{id}_body"
  end

  def trigger_id
    :"#{id}_trigger"
  end

  def before_render
    super

    html_attributes[:class] = theme_css :root, append: html_class
  end

  def call
    content_tag :div, html_attributes do
      concat render_header
      concat render_body
    end
  end

  private

  def body_classes
    theme_css :body
  end

  def header_classes
    theme_css :header
  end

  def render_header
    trigger_component = FoxTail::CollapsibleTriggerComponent.new(
      trigger_id,
      "##{body_id}",
      open: open?,
      class: header_classes,
      theme: theme
    )

    content_tag header_tag, id: id do
      render(trigger_component) do |trigger|
        content_tag :button, trigger.html_attributes do
          concat icon if icon?
          concat content_tag(:span, title)
          concat arrow if arrow?
        end
      end
    end
  end

  def render_body
    collapsible_component = FoxTail::CollapsibleComponent.new(
      body_id,
      open: open?,
      data: { FoxTail::AccordionComponent.stimulus_controller.target_key => :collapsible },
      aria: { labelledby: id },
      theme: theme
    )

    render collapsible_component do
      content_tag :div, content, class: body_classes
    end
  end
end