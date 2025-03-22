require "factory_dumps"
require "active_record"
require "factory_bot"
require "fileutils"

# Define test model
class User < ActiveRecord::Base
end

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods

  config.before(:suite) do
    # Setup test database
    ActiveRecord::Base.establish_connection(adapter: "sqlite3", database: ":memory:")

    # Create test table
    ActiveRecord::Schema.define do
      create_table :users do |t|
        t.string :name
        t.string :email
        t.integer :age
        t.timestamps
      end
    end

    # Define test factory
    FactoryBot.define do
      factory :user do
        sequence(:name) { |n| "User #{n}" }
        sequence(:email) { |n| "user#{n}@example.com" }
        age { rand(18..65) }
      end
    end
  end

  config.after(:suite) do
    # Clean up any generated files and directories
    Dir.glob("*.xls").each { |f| File.delete(f) }
    FileUtils.rm_rf("tmp/test_dumps") if Dir.exist?("tmp/test_dumps")
  end
end
