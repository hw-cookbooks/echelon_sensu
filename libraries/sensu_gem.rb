class Chef::Resource::SensuGem < Chef::Resource::GemPackage
  resource_name :sensu_gem
  provides :sensu_gem

  def initialize(name, run_context = nil)
    super
    @provider = Chef::Provider::Package::Rubygems
  end

  def gem_binary
    if ::File.exist?('/opt/sensu/embedded/bin/gem')
      '/opt/sensu/embedded/bin/gem'
    else
      'gem'
    end
  end
end
