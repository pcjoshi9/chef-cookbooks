#
# Cookbook Name:: cdb_pod
# Recipe:: default
# Author : Pradeep Joshi
# Copyright 2012, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
version_pod = node['app_cdb_pod']['version']

remote_file "#{node['cdb_base']['localdir']['cdbapps']}/pod.jar" do
  source data_bag_item('cdb-appbag','app_cdb_pod')[version_pod]['download_location']
  checksum data_bag_item('cdb-appbag','app_cdb_pod')[version_pod]['checksum']
  mode "0644"
  owner node['cdb_base']['appuser']['username']
  group node['cdb_base']['appuser']['group']
  #notifies :restart, "service[tomcat]", :delayed
  Chef::Log.info("Deploying cdb POD version #{version_pod}")
end

%w{pod}.each do |dir|
  directory "#{node['cdb_base']['localdir']['cdbapps']}/#{dir}" do
    action :nothing
    recursive true
    subscribes :delete, resources(:remote_file => "#{node['cdb_base']['localdir']['cdbapps']}/pod.jar"), :immediately
  end
end

Chef::Log.info("Deploying cdb POD Processes Completed...")
