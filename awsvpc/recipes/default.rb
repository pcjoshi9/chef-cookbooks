#
# Cookbook Name:: awsvpc
# Recipe:: default
# Author :- Pradeep Joshi
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
node.default['aws-provisioning']['aws']['ssh_username'] = 'ubuntu'
#node.default['aws-provisioning']['aws']['use_private_ip_for_ssh'] = true
#node.default['aws-provisioning']['aws']['use_private_ip_for_ssh'] = false
node.default['aws-provisioning']['aws']['key_pair'] = 'PJ'
node.default['aws-provisioning']['aws']['ami-id'] = 'ami-df6a8b9b'
node.default['aws-provisioning']['aws']['instance_type'] = 't2.micro'
node.default['aws-provisioning']['aws']['iam_creds_region'] = 'aws:default:us-west-1'
#node.default['aws-provisioning']['aws']['security_group_ids'] = %w(sg-777e3512)
#node.default['aws-provisioning']['aws']['subnet_id']['az1'] = 'subnet-e49e8286'
#node.default['aws-provisioning']['aws']['elb']['scheme'] = 'internal'


chef_gem 'chef-provisioning-aws' do
  options('--no-document --no-user-install --install-dir /opt/chefdk/embedded/lib/ruby/gems/2.1.0')
  compile_time true if respond_to?(:compile_time)
end

require 'chef/provisioning'
require 'chef/provisioning/aws_driver'

with_driver(
   node['aws-provisioning']['aws']['iam_creds_region']
)


aws_vpc 'provisioning-vpc' do
  cidr_block '10.11.12.0/24'
  internet_gateway true
  main_routes '0.0.0.0/0' => :internet_gateway
  enable_dns_hostnames true
end

aws_subnet 'provisioning-vpc-subnet-a' do
  vpc 'provisioning-vpc'
  cidr_block '10.11.12.0/26'
  availability_zone 'us-west-1b'
  map_public_ip_on_launch true
end

aws_subnet 'provisioning-vpc-subnet-b' do
  vpc 'provisioning-vpc'
  cidr_block '10.11.12.128/26'
  availability_zone 'us-west-1c'
  map_public_ip_on_launch true
end

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

machine 'provisioning-vpc-ec2-instance-a' do
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
machine 'provisioning-vpc-ec2-instance-b' do
  machine_options( 
  transport_address_location: :public_ip,
  ssh_username: 'ubuntu',
  bootstrap_options: {
    key_name: node.default['aws-provisioning']['aws']['key_pair'],
    image_id: node['aws-provisioning']['aws']['ami-id'],
    security_group_ids: ['provisioning-vpc-security-group'],
    subnet_id: 'provisioning-vpc-subnet-b',
    instance_type: node.default['aws-provisioning']['aws']['instance_type']
})
end

