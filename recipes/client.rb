include_recipe 'echelon_sensu::default'

include_recipe 'sensu::client'

remote_directory File.join(node.sensu.directory, 'plugins') do
  files_mode '755'
end

