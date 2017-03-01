#
# Cookbook Name:: cdb_pod
# Recipe:: default
#
# Copyright 2012, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#


directory node['cdb_base']['localdir']['tmp_pod'] do
  owner node['cdb_base']['appuser']['username']
  group node['cdb_base']['appuser']['group']
  mode "0755"
  action :create
  recursive true
end

directory node['cdb_base']['localdir']['storedir'] do
  owner node['cdb_base']['appuser']['username']
  group node['cdb_base']['appuser']['group']
  mode "0755"
  action :create
  recursive true
end
