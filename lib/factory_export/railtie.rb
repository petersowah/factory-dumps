module FactoryExport
  class Railtie < Rails::Railtie
    initializer "factory_export" do
      ActiveSupport.on_load(:active_record) do
        extend FactoryExport
      end
    end
  end
end
