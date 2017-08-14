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

directory "#{node[:magento2][:mage_root]}/var" do
  recursive true
  action :delete
end

execute 'Create database' do
  command "mysql -e 'CREATE DATABASE IF NOT EXISTS `#{node[:magento2][:database]}`'"
end

template "#{node[:localdev][:project_path]}/mage_setup_command.sh" do
  source 'mage_setup_command.erb'
  mode '0755'
  variables ({
  	:mage_root          => node[:magento2][:mage_root],

    :db_user            => node[:mysql][:user],
    :db_password        => node[:mysql][:password],
    :db_host            => node[:mysql][:host],
    :db_charset         => node[:mysql][:charset],
    :db_name            => node[:magento2][:database],

    :hostname           => node[:nginx][:server_name],
    :port 							=> node[:nginx][:mage_port],

    :backend_frontname  => node[:magento2][:backend_frontname],
    :language						=> node[:magento2][:language],
    :timezone						=> node[:magento2][:timezone],
    :currency						=> node[:magento2][:currency],

    :admin_lastname     => node[:magento2][:admin_lastname],
    :admin_firstname		=> node[:magento2][:admin_firstname],
    :admin_email				=> node[:magento2][:admin_email],
    :admin_user					=> node[:magento2][:admin_user],
    :admin_password			=> node[:magento2][:admin_password]
  })
  action :create
end
