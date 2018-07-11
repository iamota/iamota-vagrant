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

# Disabled due to conflict with new NFS mounting approach
# This wasn't really needed anyway.
# directory "#{node[:localdev][:project_path]}" do
#   owner node[:localdev][:owner]
#   group node[:localdev][:group]
#   mode '0777'
#   action :create
# end

directory "#{node[:localdev][:scripts_path]}" do
  #owner node[:localdev][:owner]
  #group node[:localdev][:group]
  #mode '0777'
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

# Remove auto-updater which can conflict with NFS installation during vagrant up
[ 'update-manager' ].each do |p|
    package p do
        action :remove
    end
end

# Update system MOTD with some helpful information
template '/etc/motd' do
  source 'motd.erb'
  owner 'root'
  group 'root'
  mode '0755'
  variables ({
  	:project_path => node[:localdev][:project_path]
  	})
end

# Create helpful bash aliases
template '/home/ubuntu/.bash_aliases' do
  source 'bash_aliases.erb'
  variables ({
  	:project_path => node[:localdev][:project_path]
  	})
end
