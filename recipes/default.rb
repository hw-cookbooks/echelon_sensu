#
# Cookbook Name:: echelon-sensu
# Recipe:: default
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
=begin
sensu_server = Discovery.search("sensu_server", :node => node)

unless sensu_server.name == node.name
  node.sensu.rabbitmq = sensu_server.sensu.rabbitmq.to_hash
  node.sensu.rabbitmq.host = Discovery.ipaddress(:remote_node => sensu_server, :node => node)

  Chef::Log.debug "sensu::client: sensu_server.rabbitmq.host #{node.sensu.rabbitmq.host}"
end
=end
include_recipe 'echelon_sensu::client'
