# frozen_string_literal: true

class FoxTail::ToastComponent < FoxTail::DismissibleComponent

  renders_one :header, lambda { |text, options = {}|
    options[:class] = theme_css :header, append: options[:class]
    content_tag :span, text, options
  }

  renders_one :visual, types: {
    icon: {
      as: :icon,
      renders: lambda { |icon, options = {}, &block|
        render_visual block ? capture(&block) : nil, options do |attributes|
          render FoxTail::IconBaseComponent.new(icon, attributes)
        end
      }
    },
    svg: {
      as: :svg,
      renders: lambda { |path, options = {}, &block|
        render_visual block ? capture(&block) : nil, options do |attributes|
          render FoxTail::InlineSvgComponent.new(path, attributes)
        end
      }
    },
    image: {
      as: :image,
      renders: lambda { |source, options = {}|
        options[:class] = merge_theme_css %i[visual visual/image], append: options[:class]
        image_tag source, options
      }
    }
  }

  renders_one :action, lambda { |options = {}|
    options[:class] = theme_css :action, append: options[:class]
    options[:theme] = theme
    FoxTail::ClickableComponent.new options
  }

  renders_one :dismiss_icon, lambda { |options = {}, &block|
    content = block ? capture(&block) : I18n.t("components.fox_tail.close")
    icon_options = options.slice(:icon, :variant).reverse_merge(icon: "x-mark", variant: :solid)
    icon_options[:class] = theme_css "dismiss/icon"
    icon_options[:theme] = theme
    dismiss_actions! options
    options[:class] = theme_css "dismiss/button", append: options[:class]

    content_tag :button, options do
      concat render(FoxTail::IconBaseComponent.new(icon_options[:icon], icon_options.except(:icon)))
      concat content_tag(:div, content, class: theme.css!("accessibility.sr_only"))
    end
  }

  has_option :dividers, type: :boolean, default: false
  has_option :dismissible, type: :boolean, default: true
  has_option :long_content, type: :boolean, default: false

  def before_render
    super

    with_dismiss_icon if dismissible? && !dismiss_icon
    html_attributes[:class] = theme_css :root, append: html_class
    html_attributes[:role] = :alert
  end

  def use_stimulus?
    super && (dismissible? || auto_close?)
  end

  private

  def dismiss_actions!(attributes)
    return unless use_stimulus?

    attributes[:data] ||= {}
    attributes[:data][:action] = stimulus_merger.merge_actions attributes[:data][:action],
                                                               stimulus_controller.action("dismiss")
  end

  def render_visual(content, options, &block)
    visual_options = options.extract!(:fill, :color).reverse_merge(color: :default, fill: false)
    visual_options[:fill] = !!visual_options[:fill]

    container_classes = theme_css "container/visual", attributes: visual_options

    options[:"aria-hidden"] = true
    options[:class] = merge_theme_css %i[visual visual/icon], attributes: visual_options, append: options[:class]

    content_tag :div, class: container_classes do
      concat capture(options, &block)
      concat content_tag(:span, content, class: theme.css!("accessibility.sr_only"))
    end
  end
end
