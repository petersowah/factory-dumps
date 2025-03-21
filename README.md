# Factory Export

[![Gem Version](https://badge.fury.io/rb/factory-export.svg)](https://badge.fury.io/rb/factory-export)
[![Standard](https://img.shields.io/badge/code_style-standard-brightgreen.svg)](https://github.com/standardrb/standard)

Factory Export is a Ruby gem that allows you to easily export your FactoryBot factory data to CSV and Excel formats. It's perfect for generating sample data, creating test datasets, or exporting factory-generated records for external use.

## Features

- Export factory-generated records to CSV format
- Export factory-generated records to Excel format (.xls)
- Specify which attributes to export
- Generate multiple records at once
- Automatic attribute detection from factory definitions
- Rails integration out of the box

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'factory-export'
```

And then execute:

```bash
$ bundle install
```

Or install it yourself as:

```bash
$ gem install factory-export
```

## Usage

### Basic Usage

```ruby
# Export 5 users to CSV
csv_data = FactoryExport.export_to_csv(:user, count: 5)
File.write("users.csv", csv_data)

# Export 10 products to Excel
filename = FactoryExport.export_to_excel(:product, count: 10)
# => Creates "export.xls" with 10 products
```

### Specifying Attributes

You can specify which attributes you want to export:

```ruby
# Export only name and email attributes
csv_data = FactoryExport.export_to_csv(:user, 
  count: 5,
  attributes: [:name, :email]
)

# Export specific attributes to Excel with custom filename
filename = FactoryExport.export_to_excel(:user,
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
        csv_data = FactoryExport.export_to_csv(:user, count: params[:count])
        send_data csv_data,
          filename: "users_#{Time.current.to_i}.csv",
          type: 'text/csv'
      end

      format.xls do
        filename = FactoryExport.export_to_excel(:user, 
          count: params[:count],
          filename: "users_#{Time.current.to_i}.xls"
        )
        send_file filename,
          type: 'application/vnd.ms-excel',
          disposition: 'attachment'
      end
    end
  end
end
```

### Example Factory

The gem works with any FactoryBot factory. Here's an example:

```ruby
# In your factories.rb or user_factory.rb
FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "User #{n}" }
    sequence(:email) { |n| "user#{n}@example.com" }
    age { rand(18..65) }
    created_at { Time.current }
  end
end

# In your code
csv_data = FactoryExport.export_to_csv(:user, count: 5)
# => Generates CSV with name, email, age, and created_at columns
```

## Configuration

The gem works out of the box with no configuration needed. However, you can customize the default Excel filename:

```ruby
# config/initializers/factory_export.rb
FactoryExport.configure do |config|
  config.default_excel_filename = "my_export.xls"
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

Everyone interacting in the Factory Export project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](CODE_OF_CONDUCT.md). 