# frozen_string_literal: true

class FoxTail::HrComponent < FoxTail::Base

  has_option :size, default: :normal
  has_option :shape, default: :none
  has_option :trimmed, default: false, type: :boolean

  def shape?
    shape != :none
  end

  def call
    content_tag :div, class: theme_css(:wrapper, append: html_class) do
      if content? && shape == :none
        concat tag(:hr, class: theme_css(:root))
        concat content_tag(:div, content, class: theme_css(:content))
        concat tag(:hr, class: theme_css(:root))
      else
        tag :hr, class: theme_css(:root, append: html_class)
      end
    end
  end
end
