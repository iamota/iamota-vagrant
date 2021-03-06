#
# Cookbook Name:: localdev
# Recipe:: magento2
#
# Copyright (c) 2017 iamota, All Rights Reserved.

# Create Magento 2 user
user "#{node[:magento2][:sys_user]}" do
  comment 'Magento User'
  manage_home true
  home "/home/#{node[:magento2][:sys_user]}"
  shell '/bin/bash'
  password node[:magento2][:sys_password]
end

# Create Magento 2 group
group 'www-data' do
  action :modify
  members node[:magento2][:sys_user]
  append true
end

# Create the MAGE_ROOT directory, if needed.
# directory "#{node[:magento2][:mage_root]}" do
#   owner node[:localdev][:owner]
#   group node[:localdev][:group]
#   mode '0777'
#   action :create
# end

execute 'Create database' do
  command "mysql -e 'CREATE DATABASE IF NOT EXISTS `#{node[:magento2][:database]}`'"
end

# Delete existing localdev.conf file, which will be replaced with the magento conf below.
file "#{node[:nginx][:conf_enabled]}" do
  action :delete
  notifies :restart, 'service[nginx]', :immediately
end

# Create magento2.conf file from template.
template '/etc/nginx/sites-available/magento2.conf' do
  source 'nginx-mage2.conf.erb'
  owner 'root'
  group 'root'
  mode '0755'
  variables({
    :server_name    => node[:nginx][:server_name],
    :server_port    => node[:nginx][:server_port],
    :server_root    => node[:magento2][:mage_public],
    :mage_root      => node[:magento2][:mage_root],
    :mage_mode      => node[:magento2][:mage_mode],
    :log_path       => node[:localdev][:log_path],
  })
  action :create
end

# Enable localdev nginx conf
link '/etc/nginx/sites-enabled/magento2.conf' do
  to '/etc/nginx/sites-available/magento2.conf'
  action :create
  notifies :restart, 'service[nginx]', :immediately
end


template "#{node[:magento2][:mage_root]}/tools/mage_setup_command.sh" do
  source 'mage_setup_command.erb'
  mode '0755'
  variables ({
    :hostname           => node[:nginx][:server_name],

    :db_user            => node[:mysql][:user],
    :db_password        => node[:mysql][:password],
    :db_host            => node[:mysql][:host],
    :db_charset         => node[:mysql][:charset],

    :db_name            => node[:magento2][:database],
    :mage_root          => node[:magento2][:mage_root],
    :port               => node[:magento2][:mage_port],
    :backend_frontname  => node[:magento2][:backend_frontname],
    :language           => node[:magento2][:language],
    :timezone           => node[:magento2][:timezone],
    :currency           => node[:magento2][:currency],
    :admin_lastname     => node[:magento2][:admin_lastname],
    :admin_firstname    => node[:magento2][:admin_firstname],
    :admin_email        => node[:magento2][:admin_email],
    :admin_user         => node[:magento2][:admin_user],
    :admin_password     => node[:magento2][:admin_password]
  })
  action :create
end

