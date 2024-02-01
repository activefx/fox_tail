# frozen_string_literal: true

class FoxTail::AlertComponent < FoxTail::DismissibleComponent
  SEVERITY_ICONS = { success: "check-circle", warning: "exclamation-triangle", error: "exclamation-circle" }.freeze
  DEFAULT_SEVERITY_ICON = "information-circle"

  attr_reader :id

  renders_one :header, lambda { |text_or_options = {}, options = {}, &block|
    if block
      options = text_or_options
      text_or_options = nil
    end

    text_or_options ||= capture(&block)
    options[:class] = theme_css :header, append: options[:class]
    content_tag :h3, text_or_options, options
  }

  renders_one :icon, lambda { |options = {}|
    name = options.delete(:icon) || severity_icon_name
    options[:class] = theme_css :icon, append: options[:class]
    options[:variant] ||= :mini
    FoxTail::IconBaseComponent.new name, options
  }

  renders_one :dismiss_icon, lambda { |options = {}, &block|
    content = block ? capture(&block) : I18n.t("components.fox_tail.close")
    icon_options = options.slice(:icon, :variant).reverse_merge(icon: "x-mark", variant: :solid)
    icon_options[:class] = theme_css :dismiss_icon
    dismiss_actions! options
    options[:class] = theme_css :dismiss_button, append: options[:class]
    options[:type] = :button

    content_tag :button, options do
      concat render(FoxTail::IconBaseComponent.new(icon_options[:icon], icon_options.except(:icon)))
      concat content_tag(:div, content, class: theme.css!("accessibility.sr_only"))
    end
  }

  renders_many :buttons, types: {
    button: {
      renders: lambda { |options = {}|
        options[:variant] ||= :solid
        options[:color] ||= severity
        options[:size] ||= :xs
        options[:theme] = theme
        FoxTail::ButtonComponent.new options
      },
      as: :button
    },
    dismiss: {
      renders: lambda { |options = {}|
        options[:variant] ||= :outline
        options[:color] ||= severity
        options[:size] ||= :xs
        options[:theme] = theme
        dismiss_actions! options
        FoxTail::ButtonComponent.new options
      },
      as: :dismiss_button
    }
  }

  has_option :severity, default: :info
  has_option :rounded, default: true, type: :boolean
  has_option :border, default: :none
  has_option :dismissible, default: true, type: :boolean

  def border?
    border != :none
  end

  def border
    if options[:border].is_a?(TrueClass)
      :basic
    elsif !options[:border]
      :none
    else
      (options[:border] || :none).to_sym
    end
  end

  def use_stimulus?
    super && dismissible?
  end

  private

  def severity_icon_name
    SEVERITY_ICONS.fetch severity.to_sym, DEFAULT_SEVERITY_ICON
  end

  def dismiss_actions!(attributes)
    return unless use_stimulus?

    attributes[:data] ||= {}
    attributes[:data][:action] = stimulus_merger.merge_actions attributes[:data][:action],
                                                               stimulus_controller.action("dismiss")
  end
end
