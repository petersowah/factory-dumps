# Factory Dumps

[![Gem Version](https://badge.fury.io/rb/factory-dumps.svg)](https://badge.fury.io/rb/factory-dumps)
[![Standard](https://img.shields.io/badge/code_style-standard-brightgreen.svg)](https://github.com/standardrb/standard)

Factory Dumps is a Ruby gem that allows you to easily export your FactoryBot factory data to CSV and Excel formats. It's perfect for generating sample data, creating test datasets, or exporting factory-generated records for external use.

## Features

- Export factory-generated records to CSV format
- Export factory-generated records to Excel format (.xls)
- Specify which attributes to export
- Generate multiple records at once
- Automatic attribute detection from factory definitions
- Rails integration out of the box
- Automatic creation of organized dumps directory structure
- Separate directories for CSV and Excel exports
- Configurable output directory

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'factory-dumps'
```

And then execute:

```bash
$ bundle install
```

Or install it yourself as:

```bash
$ gem install factory-dumps
```

## Setup

1. Create your factories in `spec/factories/`:

```ruby
# spec/factories/users.rb
FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "User #{n}" }
    sequence(:email) { |n| "user#{n}@example.com" }
    password { "password123" }
    created_at { Time.current }
    updated_at { Time.current }
  end
end
```

2. (Optional) Configure Factory Dumps:

```ruby
# config/initializers/factory_dumps.rb
FactoryDumps.configure do |config|
  config.dumps_directory = "db/dumps"  # Base directory for exports
  config.default_excel_filename = "export.xls"  # Default Excel filename
end
```

Note: FactoryBot is included as a dependency, so you don't need to add it separately to your Gemfile.

## Usage

### Basic Usage

```ruby
# Export 5 users to CSV (saves to db/dumps/csv/users.csv)
FactoryDumps.export_to_csv(:user, count: 5, filename: "users.csv")

# Export 10 products to Excel (saves to db/dumps/excel/export.xls)
FactoryDumps.export_to_excel(:product, count: 10)

# Export with custom filename (saves to db/dumps/excel/products.xls)
FactoryDumps.export_to_excel(:product, count: 10, filename: "products.xls")
```

### Specifying Attributes

You can specify which attributes you want to export:

```ruby
# Export only name and email attributes to CSV
FactoryDumps.export_to_csv(:user, 
  count: 5,
  attributes: [:name, :email],
  filename: "users.csv"
)

# Export specific attributes to Excel
FactoryDumps.export_to_excel(:user,
  count: 5,
  attributes: [:name, :email, :created_at],
  filename: "users_export.xls"
)
```

### Rails Integration

The gem automatically integrates with Rails. You can use it in your controllers:

```ruby
class ExportsController < ApplicationController
  def create
    respond_to do |format|
      format.csv do
        filepath = FactoryDumps.export_to_csv(:user, 
          count: params[:count],
          filename: "users_#{Time.current.to_i}.csv"
        )
        send_file filepath,
          filename: "users_#{Time.current.to_i}.csv",
          type: 'text/csv'
      end

      format.xls do
        filepath = FactoryDumps.export_to_excel(:user, 
          count: params[:count],
          filename: "users_#{Time.current.to_i}.xls"
        )
        send_file filepath,
          type: 'application/vnd.ms-excel',
          disposition: 'attachment'
      end
    end
  end
end
```

## Configuration

The gem works out of the box with no configuration needed. However, you can customize the following options:

```ruby
# config/initializers/factory_dumps.rb
FactoryDumps.configure do |config|
  config.dumps_directory = "db/dumps"  # Base directory for exports (creates csv/ and excel/ subdirectories)
  config.default_excel_filename = "export.xls"  # Default Excel filename
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b feature/my-new-feature`)
3. Make your changes
4. Run the tests (`bundle exec rake`)
5. Commit your changes (`git commit -am 'Add some feature'`)
6. Push to the branch (`git push origin feature/my-new-feature`)
7. Create new Pull Request

Please note that this project uses [Standard](https://github.com/standardrb/standard) for code formatting.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Factory Dumps project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](CODE_OF_CONDUCT.md). 