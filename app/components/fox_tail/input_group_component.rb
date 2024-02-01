# frozen_string_literal: true

class FoxTail::InputGroupComponent < FoxTail::Base
  include FoxTail::Formable

  has_option :size, default: :normal

  renders_many :items, types: {
    input: {
      as: :input,
      renders: lambda { |method_or_options = {}, options = {}|
        if method_or_options.is_a? Hash
          options = method_or_options
        else
          options[:method_name] = method_or_options
        end

        FoxTail::InputComponent.new objectify_options(options)
      }
    },
    select: {
      as: :select,
      renders: lambda { |method_or_options = {}, options = {}|
        if method_or_options.is_a? Hash
          options = method_or_options
        else
          options[:method_name] = method_or_options
        end

        FoxTail::SelectComponent.new objectify_options(options) }
    },
    button: {
      as: :button,
      renders: lambda { |method_or_options = {}, options = {}|
        if method_or_options.is_a? Hash
          options = method_or_options
        else
          options[:method_name] = method_or_options
        end

        FoxTail::ButtonComponent.new objectify_options(options) }
    },
    icon_button: {
      as: :icon_button,
      renders: lambda { |icon_or_method, *args|
        options = args.extract_options!
        icon = icon_or_method

        unless args.empty?
          icon = args.first
          options[:method_name] = icon_or_method
        end

        FoxTail::IconButtonComponent.new icon, objectify_options(options)
      }
    },
    text: {
      as: :text,
      renders: lambda { |text, options = {}|
        addon_component options do
          content_tag :span, text, class: theme_css("addon/text")
        end
      }
    },
    icon: {
      as: :icon,
      renders: lambda { |icon, options = {}|
        options[:class] = merge_theme_css(%i[addon/visual addon/icon], append: options[:class])
        options[:theme] = theme
        addon_component { render FoxTail::IconBaseComponent.new icon, options }
      }
    },
    svg: {
      as: :svg,
      renders: lambda { |path, options = {}|
        options[:class] = merge_theme_css(%i[addon/visual addon/svg], append: options[:class])
        options[:theme] = theme
        addon_component { render FoxTail::InlineSvgComponent.new(path, options) }
      }
    },
    image: {
      as: :image,
      renders: lambda { |path, options = {}|
        image_options = options.extract! :fill
        options[:class] = merge_theme_css(%i[addon/visual addon/image], append: options[:class])
        options[:theme] = theme
        addon_component(image_options) { image_tag path, options }
      }
    },
    item: {
      as: :item,
      renders: lambda { |options = {}, &block|
        options[:theme] = theme
        FoxTail::WrappedComponent.new options, &block
      }
    }
  }

  def render?
    items?
  end

  def before_render
    super

    html_attributes[:class] = theme_css(:root, append: html_class)
  end

  def call
    content_tag :div, html_attributes do
      items.each_with_index { |item, index| concat render_item(item, index) }
      concat content
    end
  end

  private

  def objectify_options(options)
    options = options.merge self.options.except(:class, :method_name, :value_array)
    options[:class] = theme_css :item, append: options[:class]
    options[:theme] = theme
    options
  end

  def item_position(index)
    if index.zero?
      :start
    elsif index == items.length - 1
      :end
    else
      :middle
    end
  end

  def addon_component(options = {}, &block)
    addon_options = options.extract! :fill, :skip_classnames
    options[:class] = theme_css(%i[addon], attributes: addon_options, append: options[:class])
    options[:theme] = theme

    FoxTail::WrappedComponent.new(options) do |wrapper|
      content_tag :div, wrapper.html_attributes do
        capture(wrapper, &block)
      end
    end
  end

  def render_item(item, index)
    return item unless item.respond_to? :with_html_class

    item.with_html_class do |html_class|
      theme_css :item, attributes: { position: item_position(index) }, prepend: html_class
    end

    item # Need to return the ViewComponent::Slot component not the actual component used
  end
end
