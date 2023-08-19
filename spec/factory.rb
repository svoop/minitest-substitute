# frozen_string_literal: true

class Config
  def initialize
    @version = 1
    @released_on = '2023-08-24'
  end
end

$_spec_config_instance = Config.new
$_spec_global_variable = :original
