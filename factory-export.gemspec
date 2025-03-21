Gem::Specification.new do |spec|
  spec.name = "factory-export"
  spec.version = "0.1.0"
  spec.authors = ["Peter Sowah"]
  spec.email = ["peter.sowah@example.com"]

  spec.summary = "Export factory data to CSV and Excel formats"
  spec.description = "A Rails gem that allows you to easily export factory data to CSV and Excel formats using your existing factories"
  spec.homepage = "https://github.com/yourusername/factory-export"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/blob/main/CHANGELOG.md"

  spec.files = Dir.glob("{bin,lib}/**/*")
  spec.require_paths = ["lib"]

  spec.add_dependency "rails", ">= 6.0"
  spec.add_dependency "factory_bot", ">= 6.0"
  spec.add_dependency "writeexcel", ">= 1.0"
  spec.add_dependency "csv", ">= 3.0"

  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "standard", "~> 1.32"
  spec.add_development_dependency "sqlite3", "~> 1.7.3"
  spec.add_development_dependency "activerecord", "~> 7.0"
end
