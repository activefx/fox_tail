# frozen_string_literal: true

class FoxTail::SelectComponent < FoxTail::InputBaseComponent
  include FoxTail::Concerns::Placeholderable

  has_option :disabled, type: :boolean, default: false
  has_option :value
  has_option :include_hidden, type: :boolean, default: true
  has_option :include_blank, type: :boolean, default: false
  has_option :choices

  renders_one :prompt, lambda { |text, selected: false, disabled: true|
    FoxTail::Select::OptionComponent.new("", disabled: disabled, selected: selected, theme: theme).with_content(text)
  }

  renders_many :select_options, types: {
    option: {
      as: :select_option,
      renders: lambda { |value, options = {}|
        options[:selected] = Array(self.value).include?(value) unless options.key? :selected
        options[:theme] = theme
        FoxTail::Select::OptionComponent.new value, options
      }
    },
    group: {
      as: :select_group,
      renders: lambda { |label, options = {}|
        options[:selected_value] = self.value
        options[:theme] = theme
        FoxTail::Select::OptionGroupComponent.new label, options
      }
    }
  }

  def value
    options[:value] ||= value_before_type_cast
  end

  def before_render
    super

    html_attributes[:class] = theme_css :root, append: html_class
    html_attributes[:multiple] = :multiple if html_attributes[:multiple]
    html_attributes[:disabled] = disabled?

    if placeholder?
      with_prompt retrieve_placeholder, selected: value_from_object.nil?
    elsif include_blank?
      with_prompt "", disabled: false, selected: value_from_object.nil?
    end

    Array(choices).each { |choice| add_choice choice } if choices.present?
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
      concat prompt if prompt?
      select_options.each { |select_option| concat select_option } if select_options?
      concat content if content?
    end
  end

  def extract_option_name_and_value(option)
    return [option, option] unless option.is_a? Array

    option
  end

  def add_choice(choice)
    name, value = extract_option_name_and_value choice

    if value.is_a? Array
      add_group_choice name, value
    else
      with_select_option(value).with_content(name)
    end
  end

  def add_group_choice(label, choices)
    with_select_group(label) do |group|
      choices.each do |choice|
        name, value = extract_option_name_and_value choice
        group.with_group_option(value).with_content(name)
      end
    end
  end
end
