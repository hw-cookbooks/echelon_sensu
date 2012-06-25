package 'build-essential'

%w(redis rabbitmq server api dashboard).each do |recipe|
  include_recipe "sensu::#{recipe}"
end

# Custom handlers
remote_directory File.join(node.sensu.directory, "handlers") do
  files_mode 0755
end

begin
  pagerduty = data_bag_item "pagerduty", node.chef_environment
  file File.join(node.sensu.directory, "conf.d", "pagerduty.json") do
    content({
              "pagerduty" => {
                "api_key" => pagerduty["api_key"]
              }
            }.to_json)
    owner node.sensu.user
  end
rescue
  Chef::Log.warn "No pagerduty config found for sensu handler"
end

begin
  campfire = data_bag_item "campfire", node.chef_environment
  file File.join(node.sensu.directory, "conf.d", "campfire.json") do
    content({
              "campfire" => {
                "account" => campfire["account"],
                "room" => campfire["room"],
                "token" => campfire["token"]
              }
            }.to_json)
    owner node.sensu.user
  end
rescue
  Chef::Log.warn "No campfire config found"
end

begin
  [:server_url, :validation_client_name, :conf_dir].each do |attr|
    if node[:echelon_sensu][attr].nil?
      node[:echelon_sensu][attr] = node[:chef_client][attr]
    end
  end
  if node[:echelon_sensu][:api_ip_addr].nil?
    node[:echelon_sensu][:api_ip_addr] = node[:sensu][:redis][:host]
  end
rescue
  Chef::Log.warn "Cookbook chef_client unavailable, echelon_sensu cannot dynamically check nodes"
  node[:echelon_sensu][:enabled] = false
end

template "/etc/sensu/handlers/default" do
  source "default.erb"
  owner "root"
  group "root"
  mode 0755
  variables (
             :api_ip_addr => node[:echelon_sensu][:api_ip_addr],
             :server_url => node[:echelon_sensu][:server_url],
             :validation_client_name => node[:echelon_sensu][:validation_client_name],
             :conf_dir => node[:echelon_sensu][:conf_dir],
             :enabled => node[:echelon_sensu][:enabled]
             )
end
