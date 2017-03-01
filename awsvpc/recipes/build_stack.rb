#
# Cookbook Name:: awsvpc
# Recipe:: default
# Copyright 2015, YOUR_COMPANY_NAME
# Author :- Pradeep Joshi
# All rights reserved - Do Not Redistribute
#

require 'pry'

node.default['aws-provisioning']['aws']['ssh_username'] = 'ubuntu'
#node.default['aws-provisioning']['aws']['use_private_ip_for_ssh'] = true
#node.default['aws-provisioning']['aws']['use_private_ip_for_ssh'] = false
node.default['aws-provisioning']['aws']['key_pair'] = 'PJ'
node.default['aws-provisioning']['aws']['ami-id'] = 'ami-dg6a8b9b'
node.default['aws-provisioning']['aws']['instance_type'] = 't2.micro'
node.default['aws-provisioning']['aws']['iam_creds_region'] = 'aws:default:us-west-1'
#node.default['aws-provisioning']['aws']['security_group_ids'] = %w(sg-777e3512)
#node.default['aws-provisioning']['aws']['subnet_id']['az1'] = 'subnet-e49e8286'
#node.default['aws-provisioning']['aws']['elb']['scheme'] = 'internal'


# chef_gem 'chef-provisioning-aws' do
#   options('--no-document --no-user-install --install-dir /opt/chefdk/embedded/lib/ruby/gems/2.1.0')
#   compile_time true if respond_to?(:compile_time)
# end

require 'chef/provisioning'
require 'chef/provisioning/aws_driver'
require 'pry'

with_driver(
   node['aws-provisioning']['aws']['iam_creds_region']
)

vpc_name = 'provisioning-vpc'

aws_vpc 'provisioning-vpc' do
  cidr_block '10.11.12.0/24'
  internet_gateway true
  main_routes '0.0.0.0/0' => :internet_gateway
  enable_dns_hostnames true
end


aws_subnet 'provisioning_vpc_PUBLIC_subnet_a' do
  vpc 'provisioning-vpc'
  cidr_block '10.11.12.0/26'
  availability_zone 'us-west-1b'
  map_public_ip_on_launch true
  route_table 'public_route_table'
end

aws_subnet 'provisioning_vpc_PRIVATE_subnet_b' do
  vpc 'provisioning-vpc'
  cidr_block '10.11.12.128/26'
  availability_zone 'us-west-1c'
  map_public_ip_on_launch false
  route_table 'public_route_table'
end

# aws_route_table 'public_route_table' do
#   routes '0.0.0.0/26' => 'provisioning_vpc_PRIVATE_subnet_b',
#          '0.0.0.0/26' => 'provisioning_vpc_PUBLIC_subnet_a',
#          '0.0.0.0/0' => :internet_gateway  
              
#   vpc vpc_name

# end

# aws_route_table 'private_route_table' do
#   routes {
#          '10.11.12.128/26' => 'provisioning_vpc_PRIVATE_subnet_b',
#          '10.11.12.0/26' => 'provisioning_vpc_PUBLIC_subnet_a',
#          '0.0.0.0/0' => :internet_gateway
#          }
#   vpc vpc_name
# end


aws_security_group 'provisioning-vpc-security-group' do
  inbound_rules [
    {:port => 22, :protocol => :tcp, :sources => ['0.0.0.0/0'] }
  ]
  outbound_rules [
    {:port => 0..65535, :protocol => :tcp, :destinations => ['0.0.0.0/0'] },
    {:port => 0..65535, :protocol => :udp, :destinations => ['0.0.0.0/0'] }
  ]
  vpc 'provisioning-vpc'
end

num_disp_servers = 2
require 'chef/data_bag'

  unless Chef::DataBag.list.key?('router_details')
    new_databag = Chef::DataBag.new
    new_databag.name('router_details')
    new_databag.save
  end

machine_batch do
  1.upto(num_disp_servers) do |i|
 machine "provisioning-vpc-ec2-ins-DISP-a#{i}" do
  machine_options( 
  transport_address_location: :public_ip,
  ssh_username: 'ubuntu',
  bootstrap_options: {
    key_name: node.default['aws-provisioning']['aws']['key_pair'],
    image_id: node['aws-provisioning']['aws']['ami-id'],
    security_group_ids: ['provisioning-vpc-security-group'],
    subnet_id: 'provisioning-vpc-subnet-a',
    instance_type: node.default['aws-provisioning']['aws']['instance_type']
})
   
  end
  #$router_ip = 'router_ip'
  $tmp_name = "provisioning-vpc-ec2-ins-DISP-a#{i}"
  $router = "name:provisioning-vpc-ec2-ins-DISP-a#{i}"
  rip_server = search(:node, $router).first
  $router_ip = rip_server['ec2']['public_ipv4']
  #binding.pry
  #$router_ip_+"#{i}" = {"id" => $tmp_name, "rtr_ip" => $router_ip}
  

  router_ip = {
  'id' => $tmp_name,
  'rtr_ip' => $router_ip
  }

  #$router_ip_+"#{i}.to_s" = { "id" => "provisioning-vpc-ec2-ins-DISP-a#{i}", "router#{i}" => "#{$router_ip}" }
  
    databag_item = Chef::DataBagItem.new
    databag_item.data_bag('router_details')
    databag_item.raw_data = router_ip
    databag_item.save
 end
end

# $router_ip = 'router_ip'
# $router = "name:provisioning-vpc-ec2-ins-DISP-a1"
# rip_server = search(:node, $router).first
# puts rip_server
# #binding.pry
# $router_ip = rip_server['ec2']['public_ipv4']
# $router_ip_1 = { "id" => "provisioning-vpc-ec2-ins-DISP-a1", "router1" => "#{$router_ip}" }
#     databag_item = Chef::DataBagItem.new
#     databag_item.data_bag('router_details')
#     databag_item.raw_data = $router_ip_1
#     databag_item.save

# num_disp_servers = 2
#  1.upto(num_disp_servers) do |i|
#  ruby_block 'find router-ip' do
#    block do 
#     Chef::Config.from_file('/etc/chef/client.rb')
#     $router = "name:provisioning-vpc-ec2-ins-DISP-a#{i}"
#     rip_server = search(:node, $router).first
#     puts rip_server
#     #$router_ip = rip_server['ec2']['public_ipv4']
#     $router_ip = '9.9.9.99'
#     #binding.pry
#     puts "Router IP: " +"$router_ip"
#     #puts $router_ip.class
#     $router_ip = { "router#{i}" => "$router_ip#{i}" }
#     databag_item = Chef::DataBagItem.new
#     databag_item.data_bag('router_details')
#     databag_item.raw_data = $router_ip
#     databag_item.save
#     only_if {search(:node, 'name:' + "provisioning-vpc-ec2-ins-DISP-a#{i}").exist? != nil}
  
#    end
#   end
# end



# num_pub_servers = 1
# machine_batch do
#   1.upto(num_pub_servers) do |i|
#  machine "provisioning-vpc-ec2-ins-PUB-a#{i}" do
#   machine_options(
#   transport_address_location: :public_ip,
#   ssh_username: 'ubuntu',
#   bootstrap_options: {
#     key_name: node.default['aws-provisioning']['aws']['key_pair'],
#     image_id: node['aws-provisioning']['aws']['ami-id'],
#     security_group_ids: ['provisioning-vpc-security-group'],
#     subnet_id: 'provisioning-vpc-subnet-a',
#     instance_type: node.default['aws-provisioning']['aws']['instance_type']
# })
#   end
#  end
# end

# num_disp_servers = 2
# machine_batch do
#   1.upto(num_disp_servers) do |i|
#  machine "provisioning-vpc-ec2-ins-DISP-b#{i}" do
#   machine_options( 
#   transport_address_location: :public_ip,
#   ssh_username: 'ubuntu',
#   bootstrap_options: {
#     key_name: node.default['aws-provisioning']['aws']['key_pair'],
#     image_id: node['aws-provisioning']['aws']['ami-id'],
#     security_group_ids: ['provisioning-vpc-security-group'],
#     subnet_id: 'provisioning-vpc-subnet-b',
#     instance_type: node.default['aws-provisioning']['aws']['instance_type']
# }) 
#   end
#  end
# end

# num_pub_servers = 1
# machine_batch do
#   1.upto(num_pub_servers) do |i|
#  machine "provisioning-vpc-ec2-ins-PUB-b#{i}" do
#   machine_options(
#   transport_address_location: :public_ip,
#   ssh_username: 'ubuntu',
#   bootstrap_options: {
#     key_name: node.default['aws-provisioning']['aws']['key_pair'],
#     image_id: node['aws-provisioning']['aws']['ami-id'],
#     security_group_ids: ['provisioning-vpc-security-group'],
#     subnet_id: 'provisioning-vpc-subnet-b',
#     instance_type: node.default['aws-provisioning']['aws']['instance_type']
# })
#   end
#  end
# end

