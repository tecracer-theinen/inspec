require 'inspec/objects/input'

module InspecPlugins::InputTestFixture
  class InputImplementation < Inspec.plugin(2, :input)
    def default_priority
      65
    end

    def fetch(profile_name, input_name)
      return nil unless test_fixture_data.key?(profile_name)
      return nil unless test_fixture_data[profile_name].key?(input_name)
      value = test_fixture_data[profile_name][input_name]
      Inspec::Input::Event.new(
        action: :fetch,
        provider: :'inspec-input-test-fixture',
        priority: default_priority,
        value: value,
        file: __FILE__,
        hit: true,
      )
    end

    def list_inputs(profile_name)
      return [] unless test_fixture_data.key?(profile_name)
      test_fixture_data[profile_name].keys
    end

    private
    def test_fixture_data
      {
        'input-test-fixture' => {
          'test_only_in_plugin' => 'only_in_plugin',
          'test_collide_plugin_higher' => 'collide_plugin_higher',
          'test_collide_inline_higher' => 'wrong',
          'test_not_mentioned_inline' => 'anything',
        }
      }
    end
  end
end
