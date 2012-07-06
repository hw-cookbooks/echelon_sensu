include_recipe 'echelon_sensu::default'

sensu_gem 'sensu-plugin' do
  action :upgrade
end
include_recipe "sensu::client"

remote_directory File.join(node.sensu.directory, "plugins") do
  files_mode 0755
end

