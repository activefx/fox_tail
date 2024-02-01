# frozen_string_literal: true

class FoxTail::DrawerTriggerComponent < FoxTail::TriggerBaseComponent
  has_option :open, default: false, type: :boolean

  def before_render
    super

    html_attributes[:class] = merge_theme_css(%W[root root/#{open? ? :open : :close}], append: html_class)
  end

  def stimulus_controller_options
    super.merge open_classes: theme_css("root/open"), closed_classes: theme_css("root/closed")
  end

  class StimulusController < FoxTail::StimulusController
    def drawer_identifier
      FoxTail::DrawerComponent.stimulus_controller_identifier
    end

    def attributes(options = {})
      attributes = super options
      attributes[:data][outlet_key(drawer_identifier)] = options[:selector]
      attributes[:data][classes_key(:open)] = options[:open_classes]
      attributes[:data][classes_key(:closed)] = options[:closed_classes]
      attributes[:data][:action] = action options.fetch(:action, :toggle), event: options.fetch(:trigger_type, :click)
      attributes
    end
  end
end
