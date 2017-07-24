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

if node[:nginx][:include_magento] == 'yes'
	# Add local server nginx config from chef template
	template '/etc/nginx/magento2.conf' do
	  source 'nginx-mage2.conf.erb'
	  owner 'root'
	  group 'root'
	  mode '0755'
	  variables({})
	  action :create
	end
end



# Add local server nginx config from chef template
template '/etc/nginx/sites-available/localdev.conf' do
  source 'nginx.conf.erb'
  owner 'root'
  group 'root'
  mode '0755'
  variables ({
    :server_root   => node[:nginx][:server_root],
    :server_name   => node[:nginx][:server_name],
    :server_port   => node[:nginx][:server_port],
    :log_path      => node[:localdev][:log_path],
    :wp_content_relative_path => node[:localdev][:wp_content_relative_path],

	:include_magento => node[:nginx][:include_magento],
	:mage_root	=> node[:nginx][:magento2][:mage_root],
	:mage_mode	=> node[:nginx][:magento2][:mage_mode],
	:mage_nginx_conf => node[:nginx][:magento2][:mage_conf]
  })
  action :create
end

# Enable localdev nginx conf
link '/etc/nginx/sites-enabled/localdev.conf' do
  to '/etc/nginx/sites-available/localdev.conf'
  action :create
  notifies :restart, resources(:service => 'nginx'), :immediately
end
