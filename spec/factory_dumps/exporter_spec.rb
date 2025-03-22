require "spec_helper"
require "csv"

RSpec.describe FactoryDumps::Exporter do
  let(:exporter) { described_class.new(:user) }

  describe "#to_csv" do
    context "with default attributes" do
      it "exports all attributes to CSV" do
        csv_data = exporter.to_csv(3)
        csv = CSV.parse(csv_data, headers: true)

        expect(csv.headers).to match_array(["id", "name", "email", "age", "created_at", "updated_at"])
        expect(csv.count).to eq(3)

        # Check first row
        first_row = csv.first
        expect(first_row["name"]).to match(/User \d+/)
        expect(first_row["email"]).to match(/user\d+@example\.com/)
        expect(first_row["age"]).to match(/\d+/)
      end
    end

    context "with specific attributes" do
      it "exports only specified attributes" do
        csv_data = exporter.to_csv(2, [:name, :email])
        csv = CSV.parse(csv_data, headers: true)

        expect(csv.headers).to match_array(["name", "email"])
        expect(csv.count).to eq(2)

        # Check first row
        first_row = csv.first
        expect(first_row["name"]).to match(/User \d+/)
        expect(first_row["email"]).to match(/user\d+@example\.com/)
        expect(first_row["age"]).to be_nil
      end
    end

    context "with invalid attributes" do
      it "raises an error for invalid attributes" do
        expect {
          exporter.to_csv(1, [:invalid_attribute])
        }.to raise_error(NoMethodError)
      end
    end
  end

  describe "#to_excel" do
    let(:test_dir) { "tmp/test_dumps" }
    let(:test_file) { File.join(test_dir, "test.xls") }

    before(:each) do
      FileUtils.mkdir_p(test_dir)
    end

    after(:each) do
      FileUtils.rm_rf(test_dir)
    end

    context "with default attributes" do
      it "exports all attributes to Excel" do
        exporter.to_excel(3, nil, test_file)
        expect(File.exist?(test_file)).to be true
        expect(File.size(test_file)).to be > 0
      end
    end

    context "with specific attributes" do
      it "exports only specified attributes" do
        exporter.to_excel(2, [:name, :email], test_file)
        expect(File.exist?(test_file)).to be true
        expect(File.size(test_file)).to be > 0
      end
    end

    context "with invalid attributes" do
      it "raises an error for invalid attributes" do
        expect {
          exporter.to_excel(1, [:invalid_attribute], test_file)
        }.to raise_error(NoMethodError)
      end
    end
  end

  describe "error handling" do
    it "raises an error for non-existent factory" do
      expect {
        described_class.new(:non_existent_factory)
      }.to raise_error(KeyError, 'Factory not registered: "non_existent_factory"')
    end
  end
end
