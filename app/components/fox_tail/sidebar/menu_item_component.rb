# frozen_string_literal: true

class FoxTail::Sidebar::MenuItemComponent < FoxTail::ClickableComponent
  renders_one :left_visual, types: {
    icon: {
      as: :left_icon,
      renders: lambda { |icon, options = {}|
        options[:class] = theme_css :visual, attributes: { position: :left, type: :icon }, append: options[:class]
        options[:theme] = theme
        FoxTail::IconBaseComponent.new icon, options
      }
    },
    svg: {
      as: :left_svg,
      renders: lambda { |path, options = {}|
        options[:class] = theme_css :visual, attributes: { position: :left, type: :svg }, append: options[:class]
        options[:theme] = theme
        FoxTail::InlineSvgComponent.new path, options
      }
    },
    image: {
      as: :left_image,
      renders: lambda { |source, options = {}|
        options[:class] = theme_css :visual, attributes: { position: :left, type: :image }, append: options[:class]
        options[:theme] = theme
        image_tag source, options
      }
    }
  }

  renders_one :right_visual, types: {
    icon: {
      as: :right_icon,
      renders: lambda { |icon, options = {}|
        options[:class] = theme_css :visual, attributes: { position: :right, type: :icon }, append: options[:class]
        options[:theme] = theme
        FoxTail::IconBaseComponent.new icon, options
      }
    },
    svg: {
      as: :right_svg,
      renders: lambda { |path, options = {}|
        options[:class] = theme_css :visual, attributes: { position: :right, type: :svg }, append: options[:class]
        options[:theme] = theme
        FoxTail::InlineSvgComponent.new path, options
      }
    },
    image: {
      as: :right_image,
      renders: lambda { |source, options = {}|
        options[:class] = theme_css :visual, attributes: { position: :right, type: :image }, append: options[:class]
        options[:theme] = theme
        image_tag source, options
      }
    },
    badge: {
      as: :badge,
      renders: lambda { |options = {}|
        options[:class] = theme_css :visual, attributes: { position: :left, type: :badge }, append: options[:class]
        options[:theme] = theme
        FoxTail::BadgeComponent.new options
      }
    }
  }

  renders_one :menu, lambda { |options = {}|
    options[:theme] = theme
    options[:id] = menu_id
    options[:level] = level + 1
    FoxTail::Sidebar::MenuComponent.new options
  }

  has_option :id
  has_option :menu_id
  has_option :selected, type: :boolean, default: false
  has_option :level, default: 0

  def initialize(html_attributes = {})
    super(html_attributes)

    options[:id] ||= "menu_item_#{SecureRandom.alphanumeric 16}"
    options[:menu_id] ||= "#{options[:id]}_menu"
  end

  def link?
    menu? ? false : super
  end

  def before_render
    super

    if menu?
      with_right_icon "chevron-down" unless right_visual
    end
  end

  def call
     content_tag :li do
       if menu?
         concat render_collapsible_trigger
         concat render_menu
       else
         render_item
       end
    end
  end

  private

  def render_collapsible_trigger
    component = FoxTail::CollapsibleTriggerComponent.new(id, "##{menu_id}", open: selected?, theme: theme)

    render component do |trigger|
      render_item trigger.html_attributes
    end
  end

  def render_item(attributes = {})
    attributes = stimulus_merger.merge_attributes html_attributes, attributes

    content_tag root_tag_name, attributes do
      concat left_visual if left_visual?
      concat content_tag(:span, content, class: theme_css(:content))
      concat right_visual if right_visual?
    end
  end

  def render_menu
    render FoxTail::CollapsibleComponent.new(menu_id, open: selected?).with_content(menu)
  end
end
