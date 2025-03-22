require 'factory_bot'
require 'factory_dumps'

# Load all factory files
Dir.glob('spec/factories/**/*.rb').each do |factory_file|
  require_relative factory_file
end

# Initialize FactoryBot
FactoryBot.find_definitions 