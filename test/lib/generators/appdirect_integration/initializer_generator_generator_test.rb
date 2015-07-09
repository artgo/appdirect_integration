require 'test_helper'
require 'generators/initializer_generator/initializer_generator_generator'

module AppdirectIntegration
  class InitializerGeneratorGeneratorTest < Rails::Generators::TestCase
    tests InitializerGeneratorGenerator
    destination Rails.root.join('tmp/generators')
    setup :prepare_destination

    # test "generator runs without errors" do
    #   assert_nothing_raised do
    #     run_generator ["arguments"]
    #   end
    # end
  end
end
