# frozen_string_literal: true

# @logical_path forms
# @component FoxTail::RangeComponent
class RangeComponentPreview < ViewComponent::Preview

  # @param disabled toggle
  # @param size select { choices: [sm,normal,lg] }
  def playground(disabled: false, size: :normal)
    render FoxTail::RangeComponent.new(disabled: disabled, size: size)
  end

  # @!group Disabled

  def active
    render FoxTail::RangeComponent.new(disabled: false)
  end

  def disabled
    render FoxTail::RangeComponent.new(disabled: true)
  end

  # @!endgroup

  # @!group Sizes

  def small
    render FoxTail::RangeComponent.new(size: :sm)
  end

  # @label Normal (Default)
  def normal
    render FoxTail::RangeComponent.new(size: :normal)
  end

  def large
    render FoxTail::RangeComponent.new(size: :lg)
  end

  # @!endgroup
end
