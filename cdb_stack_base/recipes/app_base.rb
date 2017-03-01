
directory node['cdb_base']['localdir']['cdbapps'] do
  owner node['cdb_base']['appuser']['username']
  group node['cdb_base']['appuser']['group']
  mode "0755"
  action :create
  recursive true
end


directory node['cdb_base']['localdir']['base'] do
  owner node['cdb_base']['appuser']['username']
  group node['cdb_base']['appuser']['group']
  mode "0755"
  action :create
  recursive true
end

directory node['cdb_base']['localdir']['logs'] do
  owner node['cdb_base']['appuser']['username']
  group node['cdb_base']['appuser']['group']
  mode "0755"
  action :create
  recursive true
end

directory node['cdb_base']['localdir']['config'] do
  owner node['cdb_base']['appuser']['username']
  group node['cdb_base']['appuser']['group']
  mode "0755"
  action :create
  recursive true
end

directory node['cdb_base']['localdir']['init'] do
  owner node['cdb_base']['appuser']['username']
  group node['cdb_base']['appuser']['group']
  mode "0755"
  action :create
  recursive true
end

directory node['cdb_base']['localdir']['tmp'] do
  owner node['cdb_base']['appuser']['username']
  group node['cdb_base']['appuser']['group']
  mode "0755"
  action :create
  recursive true
end

Chef::Log.info("Deploying cdb Base Configurations Completed...")
