
# Create log directory
directory "#{node[:localdev][:log_path]}" do
  # owner node[:localdev][:owner]
  # group node[:localdev][:group]
  # mode '0777'
  action :create
end
