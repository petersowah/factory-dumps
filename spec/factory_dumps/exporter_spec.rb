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
    context "with default attributes" do
      it "exports all attributes to Excel" do
        filename = exporter.to_excel(3)
        expect(File.exist?(filename)).to be true

        # Note: We can't easily read the Excel file in tests
        # So we just verify it was created with the correct name
        expect(filename).to match(/export\.xls/)
      end
    end

    context "with specific attributes" do
      it "exports only specified attributes" do
        filename = exporter.to_excel(2, [:name, :email], "test_users.xls")
        expect(File.exist?(filename)).to be true
        expect(filename).to eq("test_users.xls")
      end
    end

    context "with invalid attributes" do
      it "raises an error for invalid attributes" do
        expect {
          exporter.to_excel(1, [:invalid_attribute])
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
