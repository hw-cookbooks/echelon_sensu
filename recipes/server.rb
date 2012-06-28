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
    mode 0644
  end
rescue => e
  Chef::Log.warn "No pagerduty config found for sensu handler (#{e.class}: #{e})"
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
    mode 0644
  end
rescue => e
  Chef::Log.warn "No campfire config found for sensu handler (#{e.class}: #{e})"
end
