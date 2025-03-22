require "spec_helper"
require "fileutils"

RSpec.describe FactoryDumps do
  let(:test_dir) { "tmp/test_dumps" }

  before(:each) do
    # Reset configuration before each test
    FactoryDumps.configuration = nil
    # Clean up test directory
    FileUtils.rm_rf(test_dir) if Dir.exist?(test_dir)
  end

  after(:each) do
    # Clean up test directory
    FileUtils.rm_rf(test_dir) if Dir.exist?(test_dir)
  end

  describe ".configure" do
    it "allows setting dumps directory" do
      FactoryDumps.configure do |config|
        config.dumps_directory = test_dir
      end
      expect(FactoryDumps.configuration.dumps_directory).to eq(test_dir)
      expect(FactoryDumps.configuration.csv_directory).to eq(File.join(test_dir, "csv"))
      expect(FactoryDumps.configuration.excel_directory).to eq(File.join(test_dir, "excel"))
    end

    it "allows setting default excel filename" do
      FactoryDumps.configure do |config|
        config.default_excel_filename = "custom.xls"
      end
      expect(FactoryDumps.configuration.default_excel_filename).to eq("custom.xls")
    end
  end

  describe ".export_to_csv" do
    context "with filename" do
      it "creates csv directory and saves file" do
        FactoryDumps.configure do |config|
          config.dumps_directory = test_dir
        end

        filepath = FactoryDumps.export_to_csv(:user, count: 2, filename: "users.csv")
        expect(Dir.exist?(File.join(test_dir, "csv"))).to be true
        expect(File.exist?(filepath)).to be true
        expect(filepath).to eq(File.join(test_dir, "csv", "users.csv"))
      end
    end

    context "without filename" do
      it "returns csv data without saving" do
        csv_data = FactoryDumps.export_to_csv(:user, count: 2)
        expect(csv_data).to be_a(String)
        expect(Dir.exist?(test_dir)).to be false
      end
    end
  end

  describe ".export_to_excel" do
    it "creates excel directory and saves file" do
      FactoryDumps.configure do |config|
        config.dumps_directory = test_dir
        config.default_excel_filename = "users.xls"
      end

      filepath = FactoryDumps.export_to_excel(:user, count: 2)
      expect(Dir.exist?(File.join(test_dir, "excel"))).to be true
      expect(File.exist?(filepath)).to be true
      expect(filepath).to eq(File.join(test_dir, "excel", "users.xls"))
    end

    it "uses custom filename when provided" do
      FactoryDumps.configure do |config|
        config.dumps_directory = test_dir
      end

      filepath = FactoryDumps.export_to_excel(:user, count: 2, filename: "custom.xls")
      expect(File.exist?(filepath)).to be true
      expect(filepath).to eq(File.join(test_dir, "excel", "custom.xls"))
    end
  end
end
