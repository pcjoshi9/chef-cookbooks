#
# Cookbook Name:: cdb_block
# Recipe:: block
#
# Copyright 2012, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
version_block = node['app_cdb_block']['version']

remote_file "#{node['cdb_base']['localdir']['cdbapps']}/block.jar" do
  source data_bag_item('cdb-appbag','app_cdb_block')[version_block]['download_location']
  checksum data_bag_item('cdb-appbag','app_cdb_block')[version_block]['checksum']
  mode "0644"
  owner node['cdb_base']['appuser']['username']
  group node['cdb_base']['appuser']['group']
  #notifies :restart, "service[tomcat]", :delayed
  Chef::Log.info("Deploying cdb Block Storage version #{version_block}")
end

%w{block}.each do |dir|
  directory "#{node['cdb_base']['localdir']['cdbapps']}/#{dir}" do
    action :nothing
    recursive true
    subscribes :delete, resources(:remote_file => "#{node['cdb_base']['localdir']['cdbapps']}/block.jar"), :immediately
  end
end

Chef::Log.info("Deploying cdb Block Storage Completed...")
