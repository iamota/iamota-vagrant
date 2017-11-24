#
# Cookbook Name:: localdev
# Recipe:: nginx
#
# Copyright (c) 2016 iamota, All Rights Reserved.

# Install nginx package
package 'nginx' do
    action :install
end

# Register Service handler
service 'nginx' do
  supports [:start, :restart, :reload, :stop]
end

# Remove default site
link "/etc/nginx/sites-enabled/default" do
  action :delete
end

# Add local server nginx config from chef template
template "#{node[:nginx][:conf_available]}" do
  source 'nginx.conf.erb'
  owner 'root'
  group 'root'
  mode '0755'
  variables ({
    :server_root   => node[:nginx][:server_root],
    :server_name   => node[:nginx][:server_name],
    :server_port   => node[:nginx][:server_port],
    :client_max_body_size => node[:nginx][:client_max_body_size],
    :log_path      => node[:localdev][:log_path],
    :wp_content_relative_path => node[:localdev][:wp_content_relative_path],
  })
  action :create
end

# Enable localdev nginx conf
link "#{node[:nginx][:conf_enabled]}" do
  to "#{node[:nginx][:conf_available]}"
  action :create
  notifies :restart, resources(:service => 'nginx'), :immediately
end

