package 'build-essential'

%w(redis rabbitmq server api dashboard).each do |recipe|
  include_recipe "sensu::#{recipe}"
end

include_recipe 'echelon_sensu::default'

# Custom handlers
remote_directory File.join(node.sensu.directory, 'handlers') do
  files_mode '755'
end

begin
  pagerduty = data_bag_item 'pagerduty', node.chef_environment
  file File.join(node.sensu.directory, 'conf.d', 'pagerduty.json') do
    content({
      'pagerduty' => {
        'api_key' => pagerduty['api_key'],
      },
    }.to_json)
    mode '644'
  end
rescue => e
  Chef::Log.warn "No pagerduty config found for sensu handler (#{e.class}: #{e})"
end

begin
  campfire = data_bag_item 'campfire', node.chef_environment
  file File.join(node.sensu.directory, 'conf.d', 'campfire.json') do
    content({
      'campfire' => {
        'account' => campfire['account'],
        'room' => campfire['room'],
        'token' => campfire['token'],
      },
    }.to_json)
    mode '644'
  end
rescue => e
  Chef::Log.warn "No campfire config found for sensu handler (#{e.class}: #{e})"
end

config_args = {}
if node['recipes'].include?('chef-client::config')
  config_args[:enabled] = true
  [:server_url, :conf_dir].each do |attr|
    config_args[attr] = node['echelon_sensu'][attr] || node['chef_client'][attr]
  end
  config_args[:api_ip_addr] = node['echelon_sensu']['api_ip_addr'] || node['sensu']['redis']['host']
  config_args[:signing_key_filename] = node['echelon_sensu']['signing_key_filename'] || File.join(config_args[:conf_dir], 'client.pem')
else
  Chef::Log.warn 'Cookbook chef_client unavailable, echelon_sensu cannot dynamically check nodes'
  config_args[:enabled] = false
end

if File.exist?(config_args[:signing_key_filename])
  Chef::Log.warn "Changing group and making readable for sensu: #{config_args[:signing_key_filename]}"
  file config_args[:signing_key_filename] do
    group 'sensu'
    mode '640'
  end
end

file '/etc/sensu/conf.d/chef.json' do
  mode '644'
  content(
    JSON.pretty_generate(
      chef: config_args.merge(
        enabled: node['echelon_sensu']['enabled'] || config_args[:enabled],
        environment: Array(node['echelon_sensu']['alert_environment']),
        node_name: Chef::Config[:node_name]
      )
    )
  )
end

