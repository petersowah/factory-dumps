# Factory Dumps

A Ruby gem that allows you to export FactoryBot data to CSV and Excel formats. This is particularly useful for generating test data or sample data for your Rails applications.

## Features

- Export FactoryBot data to CSV format
- Export FactoryBot data to Excel format
- Configurable export directory structure
- Support for custom filenames
- Support for selecting specific attributes to export
- Automatic directory creation

## Installation

Add this line to your application's Gemfile:

```ruby
gem "factory-dumps", "~> 0.0.3"
```

And then execute:
```bash
$ bundle install
```

## Configuration

Create an initializer file `config/initializers/factory_dumps.rb`:

```ruby
require "factory_dumps"

Rails.application.config.after_initialize do
  FactoryDumps.configure do |config|
    config.dumps_directory = "db/dumps" # Base directory for exports (creates csv/ and excel/ subdirectories)
    config.default_excel_filename = "export.xls" # Default Excel filename
  end
end
```

## Usage

### Basic Usage

```ruby
# Create some records using FactoryBot
FactoryBot.create_list(:user, 5)

# Generate both CSV and Excel dumps
FactoryDumps.dump(:user)
```

This will create:
- `db/dumps/csv/user.csv`
- `db/dumps/excel/user.xls`

### CSV Export

You can export to CSV in two ways:

```ruby
# Method 1: Using dump (creates both CSV and Excel)
FactoryDumps.dump(:user)  # Creates db/dumps/csv/user.csv

# Method 2: Using export_to_csv (creates only CSV)
FactoryDumps.export_to_csv(:user, count: 5)  # Creates db/dumps/csv/user.csv
```

### Advanced Usage

```ruby
# With custom options
FactoryDumps.dump(:user, 
  count: 10,  # Create 10 users
  excel_filename: "custom_users.xls",  # Custom Excel filename
  attributes: [:name, :email, :phone]  # Only export these attributes
)

# Generate only CSV with custom options
FactoryDumps.export_to_csv(:user, 
  count: 5,
  filename: "users.csv",
  attributes: [:name, :email]  # Only export these attributes
)

# Generate only Excel
FactoryDumps.export_to_excel(:user, count: 5, filename: "users.xls")
```

### Directory Structure

The gem creates the following directory structure:
```
db/
  └── dumps/
      ├── csv/
      │   └── user.csv
      └── excel/
          └── user.xls
```

## Development

After checking out the repo, run `bundle install` to install dependencies. Then, run `rake spec` to run the tests.

## Contributing

Bug reports and pull requests are welcome on GitHub.

## License

The gem is available as open source under the terms of the MIT License.