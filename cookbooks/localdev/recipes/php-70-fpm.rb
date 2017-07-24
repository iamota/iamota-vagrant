#
# Cookbook Name:: localdev
# Recipe:: php7
#
# Copyright (c) 2016 iamota, All Rights Reserved.


# Install PHP 7.0 FPM package
package 'php7.0-fpm' do
    action :install
end

# Register PHP 7.0 FPM as service
service "php7.0-fpm" do
  action    [:enable, :start]
  supports  [:start, :restart, :reload, :stop]
end

# Install necessary PHP packages
[ 'php7.0',
  'php7.0-cli',
  'php7.0-curl',
  'php7.0-dev',
  'php7.0-gd',
  'php7.0-json',
  'php7.0-intl',
  'php7.0-opcache',
  'php7.0-mcrypt',
  'php7.0-mbstring',
  'php7.0-xml',
  'php7.0-xsl',
  'php7.0-zip' ].each do |p|
    package p do
        action :install
    end
end

# Install PHP 7.0 mysql package
package 'php7.0-mysql' do
    action :install
end

# Install additional PHP packages
[ 'php-apcu',
  'php-imagick',
  'php-memcache',
  'php-pear',
  'php-soap',
  'php-xdebug' ].each do |p|
    package p do
        action :install
    end
end

# Replace default www.conf with our chef template
template '/etc/php/7.0/fpm/pool.d/www.conf' do
  source 'www.conf.erb'
  owner node[:localdev][:owner]
  group node[:localdev][:group]
  mode '0755'
  variables ({
    :listen     => '127.0.0.1:9000',
    :user       => node[:localdev][:owner],
    :group      => node[:localdev][:group],
    :log_path   => node[:localdev][:log_path],
    :request_slowlog_timeout => node[:php][:request_slowlog_timeout]
  })
  action :create
  notifies :restart, resources(:service => "php7.0-fpm"), :immediately
end

# Replace default php.ini with our chef template
template '/etc/php/7.0/fpm/php.ini' do
  source 'php.ini.erb'
  owner node[:localdev][:owner]
  group node[:localdev][:group]
  mode '0755'
  variables ({
    :log_path               => node[:localdev][:log_path],

    :use_windows_syslog     => node[:php][:use_windows_syslog],
    :log_errors             => node[:php][:log_errors],
    :display_errors         => node[:php][:display_errors],
    :error_reporting        => node[:php][:error_reporting],

    :post_max_size          => node[:php][:post_max_size],
    :upload_max_filesize    => node[:php][:upload_max_filesize],
    :max_execution_time     => node[:php][:max_execution_time],
    :max_input_time         => node[:php][:max_input_time],
    :memory_limit           => node[:php][:memory_limit],

    :xdebug_remote_enable   => node[:php][:xdebug_remote_enable],
    :xdebug_remote_host     => node[:php][:xdebug_remote_host],
    :xdebug_remote_port     => node[:php][:xdebug_remote_port],
    :xdebug_remote_autostart => node[:php][:xdebug_remote_autostart],
    :xdebug_remote_connect_back => node[:php][:xdebug_remote_connect_back],
    :xdebug_halt_level      =>  node[:php][:xdebug_halt_level],
  })
  action :create
  notifies :restart, resources(:service => "php7.0-fpm"), :immediately
end

# Enable PHP mcrypt module
execute 'phpenmod mcrypt' do
  command 'phpenmod mcrypt'
  action :run
  notifies :restart, resources(:service => "php7.0-fpm"), :immediately
end

# Enable PHP xdebug module
execute 'phpenmod xdebug' do
  command 'phpenmod xdebug'
  action :run
  notifies :restart, resources(:service => "php7.0-fpm"), :immediately
end
