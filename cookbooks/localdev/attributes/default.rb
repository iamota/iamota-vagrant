default[:localdev] = {
    :project_path   => '/www/current',
    :owner          => 'www-data',
    :group          => 'www-data',
    :opsworks       => 'false',
    :debug          => 'true',
    :scripts_path   => '/www/current/tools',
    :log_path       => '/var/log',
    :wp_content_relative_path => '/wp-content'
}

default[:nginx] = {
    :server_name    => 'localdev',
    :server_port    => '80',
    :server_root    => '/www/current',
    :conf_available => '/etc/nginx/sites-available/localdev.conf',
    :conf_enabled   => '/etc/nginx/sites-enabled/localdev.conf',
    :client_max_body_size => '100m'
}

default[:mysql_server] = {
    :root_password  => 'root'
}

default[:mysql] = {
    :bind_address   => '0.0.0.0',
    :user           => 'localdev',
    :password       => 'localdev',
    :database       => 'localdev',
    :host           => 'localhost',
    :port           => '3306',
    :charset        => 'utf8mb4',
    :collate        => 'utf8mb4_unicode_ci'
}

default[:php] = {
    :use_windows_syslog     => '0',
    :log_errors             => 'On',
    :display_errors         => 'On',
    :error_reporting        => 'E_ALL & ~E_DEPRECATED & ~E_STRICT',

    :memory_limit           => '256M',
    :post_max_size          => '120M',
    :upload_max_filesize    => '100M',
    :max_execution_time     => '300s',
    :max_input_time         => '180s',

    :xdebug_remote_enable   => '1',
    :xdebug_remote_autostart => '1',
    :xdebug_remote_connect_back => '0',
    :xdebug_remote_host     => 'localhost',
    :xdebug_remote_port     => '9000',
    :xdebug_halt_level      => '0',

    :request_slowlog_timeout => '15s'
}

default[:wp] = {
    :theme          => 'mytheme',
    :post_revisions => '15',
    :table_prefix   => 'wp_',
}

default[:magento2] = {
	:include		=> 'no',
    :sys_user       => 'magento',
    :sys_password   => '$1$7uSfCs9m$EPK3zsmQoe4D69V6uI8yF1', # magento
    :database       => 'magento',
    :mage_mode 		=> 'developer',
	:mage_root 		=> '/www/current',
    :mage_public    => '/www/current/pub',
    :mage_port      => '8080',
	:language		=> 'en_US',
	:timezone		=> 'America/Vancouver',
	:currency		=> 'CAD',
	:backend_frontname => 'admin',
	:admin_firstname => 'iamota',
	:admin_lastname => 'iamota',
	:admin_email    => 'localdev@iamota.com',
	:admin_user     => 'iamotaadmin',
	:admin_password => 'iamota1234'
}

default[:cache] = {
    :driver         => 'memcache',
    :host           => 'localhost',
    :port           => '11211',
    :namespace      => '',
}
