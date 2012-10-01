service "sensu-client" do
  action [:disable, :stop]
end

gem_package "sensu" do
  action :purge
end
