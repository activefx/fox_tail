# frozen_string_literal: true

class FoxTail::SpinnerComponent < FoxTail::InlineSvgComponent
  has_option :color, default: :default
  has_option :size, default: :normal

  def initialize(html_attributes = {})
    path = html_attributes.delete(:path) { self.class.spinner_path }
    super path, html_attributes
  end

  def before_render
    super

    html_attributes[:"aria-hidden"] = true
    html_attributes[:role] = :status
  end

  def html_class
    theme_css append: super
  end

  class << self
    def spinner_path
      FoxTail.root.join "app/assets/vendor/spinner.svg"
    end
  end
end
