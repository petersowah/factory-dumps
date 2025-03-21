module FactoryDumps
  class Railtie < Rails::Railtie
    initializer "factory_dumps" do
      ActiveSupport.on_load(:active_record) do
        extend FactoryDumps
      end
    end
  end
end
