#
# Cookbook Name:: localdev
# Recipe:: mysql
#
# Copyright (c) 2016 iamota, All Rights Reserved.

# Install MySQL packages
[ 'mysql-server',
  'mysql-common',
  'mysql-client' ].each do |p|
    package p do
        action :install
    end
end

# Register MySQL as service
service "mysql" do
  supports  [:start, :restart, :stop]
end

# Remove default my.cnf
# link "/etc/mysql/my.cnf" do
#   action :delete
# end

# Replace default my.cnf with our chef template
template '/etc/mysql/my.cnf' do
  source 'my.cnf.erb'
  owner node[:localdev][:owner]
  group node[:localdev][:group]
  mode '0755'
  variables ({
    :charset        => node[:mysql][:charset],
    :port           => node[:mysql][:port],
    :bind_address   => node[:mysql][:bind_address],
    # :error_log      => "#{node[:localdev][:log_path]}/mysql",
    :mysqld_options => {}
  })
  action :create
  notifies :restart, resources(:service => "mysql"), :immediately
end


# Secure the MySQL installation
# execute 'mysql_secure_installation' do
#   command "mysql_secure_installation --use-default --user=root --password=#{node[:mysql_server][:root_password]}"
# end


# Make MySQL less secure because development.
# [ 'SET GLOBAL validate_password_length = 0',
#   'SET GLOBAL validate_password_number_count = 0',
#   'SET GLOBAL validate_password_mixed_case_count = 0',
#   'SET GLOBAL validate_password_special_char_count = 0',
#   'SET GLOBAL validate_password_policy = LOW' ].each do |cmd|
#     execute cmd do
#         command "mysql -e '#{cmd}'"
#     end
# end

execute 'Create database' do
  command "mysql -e 'CREATE DATABASE IF NOT EXISTS `#{node[:mysql][:database]}`'"
end

execute 'Delete any old database users' do
  command "mysql -e 'DROP USER IF EXISTS \"#{node[:mysql][:user]}\"@\"%\"'"
  not_if { node[:mysql][:user] == 'root'}
end

execute 'Create database user' do
  command "mysql -e 'CREATE USER IF NOT EXISTS \"#{node[:mysql][:user]}\"@\"%\" IDENTIFIED BY \"#{node[:mysql][:password]}\"'"
end

execute 'Create database user privileges' do
  command "mysql -e 'GRANT ALL ON *.* TO \"#{node[:mysql][:user]}\"@\"%\"'"
end

execute 'Flush privileges' do
  command "mysql -e 'FLUSH PRIVILEGES'"
end

