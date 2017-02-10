# Replace default www.conf with our chef template
template "#{node[:localdev][:project_path]}/.env" do
  source 'env.erb'
  owner node[:localdev]['owner']
  group node[:localdev]['group']
  mode '0755'
  variables ({
    :environment        => 'localhost',

    :db_name            => node[:mysql][:database],
    :db_user            => node[:mysql][:user],
    :db_password        => node[:mysql][:password],
    :db_host            => node[:mysql][:host],
    :db_charset         => node[:mysql][:charset],
    :db_collate         => node[:mysql][:collate],

    :cache_driver       => node[:cache][:driver],
    :cache_host         => node[:cache][:host],
    :cache_port         => node[:cache][:port],
    :cache_namespace    => node[:cache][:namespace],

    :wp_table_prefix    => node[:wp][:table_prefix],
    :wp_theme           => node[:wp][:theme],
    :wp_post_revisions  => node[:wp][:post_revisions],
    :wp_memory_limit    => node[:wp][:memory_limit],
    :wp_lang            => node[:wp][:lang],

    :debug              => node[:localdev][:debug],
    :opsworks           => node[:localdev][:opsworks],

  })
  action :create
end
