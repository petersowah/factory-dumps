require "csv"
require "writeexcel"
require "factory_bot"

module FactoryDumps
  class Exporter
    def initialize(factory_name)
      @factory_name = factory_name.to_sym
      @factory = nil
      FactoryBot.factories.each do |factory|
        if factory.name == @factory_name
          @factory = factory
          break
        end
      end
      raise KeyError, "Factory '#{factory_name}' not found" unless @factory
    end

    def to_csv(count = 1, attributes = nil)
      records = generate_records(count)
      attributes ||= get_default_attributes

      CSV.generate do |csv|
        csv << attributes
        records.each do |record|
          csv << attributes.map { |attr| record.send(attr) }
        end
      end
    end

    def to_excel(count = 1, attributes = nil, filename = "export.xls")
      records = generate_records(count)
      attributes ||= get_default_attributes

      workbook = WriteExcel.new(filename)
      worksheet = workbook.add_worksheet

      attributes.each_with_index do |attr, col|
        worksheet.write(0, col, attr.to_s)
      end

      records.each_with_index do |record, row|
        attributes.each_with_index do |attr, col|
          worksheet.write(row + 1, col, record.send(attr))
        end
      end

      workbook.close
      filename
    end

    private

    def generate_records(count)
      Array.new(count) { FactoryBot.create(@factory_name) }
    end

    def get_default_attributes
      model_class = @factory.build_class
      model_class.column_names.map(&:to_sym)
    end
  end
end
