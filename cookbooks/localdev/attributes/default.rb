default[:localdev] = {
    :project_path   => '/www/current',
    :owner          => 'www-data',
    :group          => 'www-data',
    :opsworks       => 'false',
    :debug          => 'true',
    :log_path       => '/www/current/logs',
    :wp_content_relative_path => '/files'
}

default[:nginx] = {
    :server_name    => 'localdev',
    :server_port    => '80',
    :server_root    => '/www/current/public',
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
    :display_errors         => 'Off',
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

    :request_slowlog_timeout => '10s'
}

default[:wp] = {
    :theme          => 'mytheme',
    :post_revisions => '15',
    :table_prefix   => 'wp_',
}

default[:cache] = {
    :driver         => 'memcache',
    :host           => 'localhost',
    :port           => '11211',
    :namespace      => '',
}
