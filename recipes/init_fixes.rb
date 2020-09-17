
if node['echelon_sensu']['init_fixes']
  remote_directory '/etc/init.d' do
    files_mode '755'
  end
end
