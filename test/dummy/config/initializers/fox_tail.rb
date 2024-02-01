# frozen_string_literal: true

ActiveSupport.on_load(:fox_tail) do
  TailwindTheme.missing_classname = ->(path) {
    Rails.logger.debug "[TailwindTheme] Missing path '#{path.join(".")}'"
    nil
  }
end
