include_recipe 'echelon_sensu::default'

include_recipe "sensu::client"

remote_directory File.join(node.sensu.directory, "plugins") do
  files_mode 0755
end

sensu_gem 'sensu-plugin' do
  action :upgrade
end
