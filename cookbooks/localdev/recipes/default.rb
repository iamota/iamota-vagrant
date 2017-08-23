#
# Cookbook Name:: localdev
# Recipe:: default
#
# Copyright (c) 2016 iamota, All Rights Reserved.


# Update apt package database before installing any new packages
# execute "update-upgrade" do
#   command "apt-get update && apt-get upgrade -y"
#   action :run
# end

directory "#{node[:localdev][:project_path]}" do
  owner node[:localdev][:owner]
  group node[:localdev][:group]
  mode '0777'
  action :create
end

directory "#{node[:localdev][:scripts_path]}" do
  owner node[:localdev][:owner]
  group node[:localdev][:group]
  mode '0777'
  action :create
end

# Install some basics
[ 'language-pack-en', # Fix annoying locale issue
  'unzip',
  'mlocate',
  'screen',
  'fontforge',
  'libcurl3',
  'curl' ].each do |p|
    package p do
        action :install
    end
end

template '/etc/motd' do
  source 'motd.erb'
  owner 'root'
  group 'root'
  mode '0755'
  variables ({
  	:project_path => node[:localdev][:project_path]
  	})
end

template '/home/ubuntu/.bash_aliases' do
  source 'bash_aliases.erb'
  variables ({
  	:project_path => node[:localdev][:project_path]
  	})
end
