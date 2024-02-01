# frozen_string_literal: true

##
# Displays an icon inline
class FoxTail::IconComponent < FoxTail::IconBaseComponent
  attr_reader :color, :size

  has_option :color, default: :default
  has_option :size, default: :normal

  protected

  def html_class
    theme_css :root, append: super
  end
end
