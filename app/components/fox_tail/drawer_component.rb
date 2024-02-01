# frozen_string_literal: true

class FoxTail::DrawerComponent < FoxTail::Base
  include FoxTail::Controllable

  renders_one :close_button, types: {
    icon: {
      as: :close_icon,
      renders: lambda { |icon_or_options = {}, options = {}, icon_options = {}|
        if icon_or_options.is_a? Hash
          icon_options = options
          options = icon_or_options
          icon_or_options = "x-mark"
        end

        options[:class] = theme_css("close/button", append: options[:class])
        options[:theme] = theme
        options[:data] ||= {}
        icon_options[:class] = theme_css("close/icon", append: icon_options[:class])
        icon_options[:theme] = theme

        if use_stimulus?
          options[:data][:action] = stimulus_merger.merge_actions options[:data][:action],
                                                                  stimulus_controller.action(:hide)
        end

        content_tag :button, options do
          concat render(FoxTail::IconBaseComponent.new(icon_or_options, icon_options))
          concat content_tag(:span, I18n.t("fox_tail.close"), class: theme_css(:close))
        end
      }
    }
  }

  renders_one :notch, lambda { |options = {}|
    options[:class] = theme_css(:notch, append: options[:class])
    content_tag :span, nil, options
  }

  has_option :placement, default: :left
  has_option :body_scrolling, type: :boolean, default: false
  has_option :backdrop, type: :boolean, default: true
  has_option :swipeable_edge, default: false
  has_option :open, type: :boolean, default: false
  has_option :border, type: :boolean, default: false
  has_option :rounded, type: :boolean, default: false
  has_option :tag_name, default: :div

  def before_render
    super

    html_attributes[:class] = merge_theme_css(
      [:root, "root/#{open? ? :visible : :hidden}", !open? && swipeable_edge_class],
      append: "#{html_class} #{swipeable_edge_class}"
    )

    html_attributes[:tab_index] ||= -1
    html_attributes[:aria] ||= {}
    html_attributes[:aria][:hidden] = open?
  end

  def call
    content_tag tag_name, html_attributes do
      concat close_button if close_button?
      concat notch if notch?
      yield if block_given?
      concat content
    end
  end

  def stimulus_controller_options
    {
      backdrop: backdrop?,
      body_scrolling: body_scrolling?,
      open: open?,
      visible_classes: theme_css("root/visible"),
      hidden_classes: merge_theme_css(["root/hidden", swipeable_edge_css_path], append: swipeable_edge_class),
      backdrop_classes: theme_css(:backdrop),
      body_classes: theme_css(:body)
    }
  end

  private

  def swipeable_edge_css_path
    return if !swipeable_edge? || swipeable_edge.is_a?(String)

    :swipeable_edge
  end

  def swipeable_edge_class
    return unless swipeable_edge.is_a? String

    swipeable_edge
  end

  class StimulusController < FoxTail::StimulusController
    def attributes(options = {})
      attributes = super options
      attributes[:data][value_key(:backdrop)] = options[:backdrop]
      attributes[:data][value_key(:body_scrolling)] = options[:body_scrolling]
      attributes[:data][value_key(:open)] = options[:open]
      attributes[:data][classes_key(:visible)] = options[:visible_classes]
      attributes[:data][classes_key(:hidden)] = options[:hidden_classes]
      attributes[:data][classes_key(:backdrop)] = options[:backdrop_classes]
      attributes[:data][classes_key(:body)] = options[:body_classes]
      attributes
    end
  end
end
