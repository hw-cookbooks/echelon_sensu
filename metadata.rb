name 'hw_cookbooks_echelon_sensu'
maintainer       'Heavy Water Inc.'
maintainer_email 'chrisroberts.code@gmail.com'
license          'Apache-2.0'
description      'Installs/Configures echelon based sensu'
version          '0.0.3'

%w(ubuntu debian redhat centos).each do |os|
  supports os
end

depends 'sensu'
depends 'discovery'
