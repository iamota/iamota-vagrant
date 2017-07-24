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
