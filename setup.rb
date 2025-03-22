require 'factory_bot'
require 'factory_dumps'

Dir.glob('spec/factories/**/*.rb').each do |factory_file|
  require_relative factory_file
end

FactoryBot.find_definitions 