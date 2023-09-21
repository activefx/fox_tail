# frozen_string_literal: true

class Flowbite::SelectComponent < Flowbite::InputBaseComponent
  has_option :disabled, type: :boolean, default: false
  has_option :value
  has_option :include_hidden, type: :boolean, default: true

  renders_one :placeholder, lambda { |text, selected: false, disabled: true|
    Flowbite::Select::OptionComponent.new("", disabled: disabled, selected: selected).with_content(text)
  }

  renders_many :select_options, types: {
    option: {
      as: :select_option,
      renders: lambda { |value, options = {}|
        options[:selected] = Array(self.value).include?(value) unless options.key? :selected
        Flowbite::Select::OptionComponent.new value, options
      }
    },
    group: {
      as: :select_group,
      renders: lambda { |label, options = {}|
        options[:selected_value] = self.value
        Flowbite::Select::OptionGroupComponent.new label, options
      }
    }
  }

  def value
    options[:value] ||= value_before_type_cast
  end

  def before_render
    super

    html_attributes[:class] = classnames theme.apply(:root, self), html_class
    html_attributes[:multiple] = :multiple if html_attributes[:multiple]
  end

  def call
    capture do
      concat render_hidden if html_attributes[:multiple].present? && include_hidden?
      concat render_select
    end
  end

  protected

  def can_read_only?
    false
  end

  def can_disable?
    true
  end

  private

  def render_hidden
    tag :input, disabled: disabled?, name: html_attributes[:name], type: :hidden, value: "", autocomplete: :off
  end

  def render_select
    content_tag :select, html_attributes do
      concat placeholder if placeholder?
      select_options.each { |select_option| concat select_option } if select_options?
      concat content if content?
    end
  end
end
