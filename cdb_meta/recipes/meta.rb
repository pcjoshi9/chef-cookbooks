#
# Cookbook Name:: cdb_meta 
# Recipe:: default
#
# Copyright 2012, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
version_meta = node['app_cdb_meta']['version']

remote_file "#{node['cdb_base']['localdir']['cdbapps']}/meta.jar" do
  source data_bag_item('cdb-appbag','app_cdb_meta')[version_meta]['download_location']
  checksum data_bag_item('cdb-appbag','app_cdb_meta')[version_meta]['checksum']
  mode "0644"
  owner node['cdb_base']['appuser']['username']
  group node['cdb_base']['appuser']['group']
  #notifies :restart, "service[tomcat]", :delayed
  Chef::Log.info("Deploying cdb Metadata Processes version #{version_meta}")
end

%w{meta}.each do |dir|
  directory "#{node['cdb_base']['localdir']['cdbapps']}/#{dir}" do
    action :nothing
    recursive true
    subscribes :delete, resources(:remote_file => "#{node['cdb_base']['localdir']['cdbapps']}/meta.jar"), :immediately
  end
end

Chef::Log.info("Deploying cdb Metadata Processes Completed...")
