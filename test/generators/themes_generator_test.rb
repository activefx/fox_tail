# frozen_string_literal: true

require 'test_helper'
require 'generators/fox_tail/themes_generator'

class ThemesGeneratorTest < Rails::Generators::TestCase
  tests FoxTail::ThemesGenerator
  destination File.expand_path("../../../tmp/generators", __FILE__)
  setup :prepare_destination

  def test_copy_default_theme
    run_generator
    assert_file "config/theme.yml"
  end
end
