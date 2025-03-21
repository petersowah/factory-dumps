require "spec_helper"

RSpec.describe FactoryExport do
  describe ".export_to_csv" do
    it "exports factory data to CSV" do
      csv_data = described_class.export_to_csv(:user, count: 2)
      csv = CSV.parse(csv_data, headers: true)

      expect(csv.headers).to match_array(["id", "name", "email", "age", "created_at", "updated_at"])
      expect(csv.count).to eq(2)
    end

    it "accepts specific attributes" do
      csv_data = described_class.export_to_csv(:user, count: 1, attributes: [:name, :email])
      csv = CSV.parse(csv_data, headers: true)

      expect(csv.headers).to match_array(["name", "email"])
      expect(csv.count).to eq(1)
    end
  end

  describe ".export_to_excel" do
    it "exports factory data to Excel" do
      filename = described_class.export_to_excel(:user, count: 2)
      expect(File.exist?(filename)).to be true
      expect(filename).to match(/export\.xls/)
    end

    it "accepts specific attributes and filename" do
      filename = described_class.export_to_excel(:user, count: 1, attributes: [:name, :email], filename: "test.xls")
      expect(File.exist?(filename)).to be true
      expect(filename).to eq("test.xls")
    end
  end
end
