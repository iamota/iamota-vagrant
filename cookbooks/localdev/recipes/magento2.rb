#
# Cookbook Name:: localdev
# Recipe:: magento2
#
# Copyright (c) 2016 iamota, All Rights Reserved.

# Install Magento 2 packages
# [ '' ].each do |p|
#     package p do
#         action :install
#     end
# end

directory "#{node[:magento2][:mage_root]}" do
  owner node[:localdev][:owner]
  group node[:localdev][:group]
  mode '0777'
  action :create
end

execute 'Create database' do
  command "mysql -e 'CREATE DATABASE IF NOT EXISTS `#{node[:magento2][:database]}`'"
end
