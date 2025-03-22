require "factory_dumps/version"
require "factory_dumps/exporter"
require "factory_dumps/railtie" if defined?(Rails)
require "fileutils"

module FactoryDumps
  class Error < StandardError; end

  class << self
    attr_accessor :configuration

    def configure
      self.configuration ||= Configuration.new
      yield(configuration)
    end
  end

  class Configuration
    attr_accessor :default_excel_filename, :dumps_directory

    def initialize
      @default_excel_filename = "export.xls"
      @dumps_directory = "db/dumps"
    end
  end

  def self.export_to_csv(factory_name, count: 1, attributes: nil, filename: nil)
    exporter = Exporter.new(factory_name)
    csv_data = exporter.to_csv(count, attributes)
    
    if filename
      ensure_dumps_directory
      filepath = File.join(configuration&.dumps_directory || "db/dumps", filename)
      File.write(filepath, csv_data)
      filepath
    else
      csv_data
    end
  end

  def self.export_to_excel(factory_name, count: 1, attributes: nil, filename: configuration&.default_excel_filename || "export.xls")
    ensure_dumps_directory
    filepath = File.join(configuration&.dumps_directory || "db/dumps", filename)
    Exporter.new(factory_name).to_excel(count, attributes, filepath)
  end

  private

  def self.ensure_dumps_directory
    dir = configuration&.dumps_directory || "db/dumps"
    FileUtils.mkdir_p(dir)
  end
end
