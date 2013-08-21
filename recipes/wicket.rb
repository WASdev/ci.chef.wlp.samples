serverName = "WicketSample"

# install sample
install_sample "wicket" do
  location "osi/wicket/WicketSample.jar"
  server_name serverName
end

# define service beforehand - otherwise notifications from ruby_block won't work
service "wlp-#{serverName}" do
  supports :start => true, :restart => true, :stop => true, :status => true
  action :nothing
end

# replace the server.xml with an updated one 
include_recipe "wlp::serverconfig"

# add the server.xml include file for the Wicket application 
cookbook_file "#{node['wlp']['base_dir']}/wlp/usr/shared/config/WicketSampleApp.xml" do
  source "WicketSampleApp.xml"
  mode "0644"
end

# start service
wlp_server serverName do
  action :start
end
