require "factory_dumps/version"
require "factory_dumps/exporter"
require "factory_dumps/railtie" if defined?(Rails)

module FactoryDumps
  class Error < StandardError; end

  def self.export_to_csv(factory_name, count: 1, attributes: nil)
    Exporter.new(factory_name).to_csv(count, attributes)
  end

  def self.export_to_excel(factory_name, count: 1, attributes: nil, filename: "export.xls")
    Exporter.new(factory_name).to_excel(count, attributes, filename)
  end
end
