# frozen_string_literal: true

# @logical_path forms
# @component FoxTail::FileInputComponent
class FileInputComponentPreview < ViewComponent::Preview

  # @param size select {choices: [sm,normal,lg]}
  # @param state select {choices: [default,valid,invalid]}
  # @param disabled toggle
  # @param multiple toggle
  def playground(size: :normal, state: :default, disabled: false, multiple: false)
    render FoxTail::FileInputComponent.new(size: size, state: state, disabled: disabled, multiple: multiple)
  end

  # @!group Disabled

  def active
    render FoxTail::FileInputComponent.new(disabled: false)
  end

  def disabled
    render FoxTail::FileInputComponent.new(disabled: true)
  end

  # @!endgroup

  # @!group Sizes

  def small
    render FoxTail::FileInputComponent.new(size: :sm)
  end

  # @label Normal (Default)
  def normal
    render FoxTail::FileInputComponent.new(size: :normal)
  end

  def large
    render FoxTail::FileInputComponent.new(size: :lg)
  end

  # @!endgroup

  # @!group Multiple

  def single
    render FoxTail::FileInputComponent.new(multiple: false)
  end

  def multiple
    render FoxTail::FileInputComponent.new(multiple: true)
  end

  # @!endgroup

  # @!group States

  def default
    render FoxTail::FileInputComponent.new(state: :default)
  end

  def valid
    render FoxTail::FileInputComponent.new(state: :valid)
  end

  def invalid
    render FoxTail::FileInputComponent.new(state: :invalid)
  end

  # @!endgroup
end
