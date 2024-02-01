# frozen_string_literal: true

# @logical_path forms
# @component FoxTail::InputGroupComponent
# @component FoxTail::InputGroup::AddonComponent
class InputGroupComponentPreview < ViewComponent::Preview
  # @param size select {choices: [sm,normal,lg]}
  def search(size: :normal)
    render FoxTail::InputGroupComponent.new(size: size) do |c|
      c.with_input(type: :search, placeholder: "Search for ...") do |input|
        input.with_left_icon("magnifying-glass")
      end
      c.with_icon_button("magnifying-glass", color: :green, variant: :solid, type: :submit) do
        "Search"
      end
    end
  end

  # @param size select {choices: [sm,normal,lg]}
  def button(size: :normal)
    render FoxTail::InputGroupComponent.new(size: size) do |c|
      c.with_input(type: :search, placeholder: "Search for ...") do |input|
        input.with_left_icon("magnifying-glass")
      end
      c.with_button(color: :green, variant: :solid, type: :submit) do |btn|
        btn.with_right_icon "chevron-right"
        "Search"
      end
    end
  end

  # @param size select {choices: [sm,normal,lg]}
  def dropdown(size: :normal)
    render_with_template locals: { size: size }
  end

  # @param size select {choices: [sm,normal,lg]}
  def label(size: :normal)
    render FoxTail::InputGroupComponent.new(size: size) do |c|
      c.with_input type: :url, placeholder: "mydomain", class: "text-right"
      c.with_text ".example.com"
    end
  end

  # @param size select {choices: [sm,normal,lg]}
  def icon(size: :normal)
    render FoxTail::InputGroupComponent.new(size: size) do |c|
      c.with_icon "envelope"
      c.with_input type: :email, placeholder: "username@domain.com"
    end
  end

  # @param image
  # @param size select {choices: [sm,normal,lg]}
  # @param fill toggle
  def image(image: "users/thomas-lean.png", size: :normal, fill: false)
    render FoxTail::InputGroupComponent.new(size: size) do |c|
      c.with_image image, fill: fill
      c.with_input type: :email, placeholder: "username@domain.com"
    end
  end
end
