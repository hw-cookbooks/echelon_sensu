maintainer       "Heavy Water Inc."
maintainer_email "chrisroberts.code@gmail.com"
license          "Apache 2.0"
description      "Installs/Configures echelon based sensu"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "0.0.2"

%w{ubuntu debian redhat centos}.each do |os|
  supports os
end

depends "sensu"
depends "discovery"

suggests "iptables"
