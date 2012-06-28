
if(node[:echelon_sensu][:init_fixes])
  remote_directory '/etc/init.d' do
    files_mode 0755
  end
end
