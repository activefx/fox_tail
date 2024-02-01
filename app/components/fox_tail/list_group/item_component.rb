# frozen_string_literal: true

class FoxTail::ListGroup::ItemComponent < FoxTail::ClickableComponent
  renders_one :visual, types: {
    icon: {
      as: :icon,
      renders: lambda { |icon, options = {}|
        options[:class] = theme_css(:visual, append: options[:class])
        options[:theme] = theme
        FoxTail::IconBaseComponent.new icon, options
      }
    },
    svg: {
      as: :svg,
      renders: lambda { |path, options = {}|
        options[:class] = theme_css(:visual, append: options[:class])
        options[:theme] = theme
        FoxTail::InlineSvgComponent.new path, options
      }
    },
    image: {
      as: :image,
      renders: lambda { |source, options = {}|
        options[:class] = theme_css(:visual, append: options[:class])
        image_tag source, options
      }
    }
  }

  renders_one :badge, lambda { |options = {}|
    options.reverse_merge! pill: true
    options[:class] = theme_css(:badge, append: options[:class])
    options[:theme] = theme
    FoxTail::BadgeComponent.new options
  }

  has_option :static, type: :boolean, default: false
  has_option :flush, type: :boolean, default: false
  has_option :selected, type: :boolean, default: false

  def root_tag_name
    static? ? :div : super
  end

  def hoverable?
    !static?
  end

  def render?
    content?
  end

  def before_render
    super

    if selected?
      html_attributes[:aria] ||= {}
      html_attributes[:aria][:current] = true
    end
  end

  def call
    super do
      concat visual if visual?
      concat content
      concat badge if badge?
    end
  end
end
