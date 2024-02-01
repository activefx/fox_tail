# frozen_string_literal: true

class FoxTail::ProgressBarComponent < FoxTail::Base
  include FoxTail::Controllable

  attr_reader :value

  has_option :size, default: :normal
  has_option :color, default: :default
  has_option :show_label, type: :boolean, default: false
  has_option :controlled, type: :boolean, default: false

  def initialize(value, html_attributes = {})
    super(html_attributes)
    @value = value
  end

  def before_render
    super

    html_attributes[:class] = theme_css(:root, append: html_class)
    html_attributes[:aria] ||= {}
    html_attributes[:aria][:valuenow] = value
    html_attributes[:aria][:valuemin] = 0
    html_attributes[:aria][:valuemax] = 100
  end

  def call
    content_tag :div, html_attributes do
      content_tag :div, label, bar_attributes
    end
  end

  def use_stimulus?
    controlled? && super
  end

  def stimulus_controller_options
    { value: value, update_label: show_label? && !content? }
  end

  private

  def label
    return unless show_label?
    return content if content?

    "#{value.round}%"
  end

  def bar_attributes
    attributes = { class: theme_css(:bar), style: "width: #{value}%" }
    return attributes unless use_stimulus?

    attributes[:data] = {}
    attributes[:data][stimulus_controller.target_key] = :bar
    attributes
  end

  class StimulusController < FoxTail::StimulusController
    def attributes(options = {})
      attributes = super
      attributes[:data][value_key(:progress)] = options[:value]
      attributes[:data][value_key(:update_label)] = options[:update_label]
      attributes
    end
  end
end
