serverName = "GrailsSample"

# install sample
install_sample "grails" do
  location "osi/grails/GrailsSample.jar"
  server_name serverName
end

# define service beforehand - otherwise notifications from ruby_block won't work
service "wlp-#{serverName}" do
  supports :start => true, :restart => true, :stop => true, :status => true
  action :nothing
end

# update host & port information
ruby_block "update_server_xml" do
  block do
    config = Liberty::Configuration.load("#{node['wlp']['base_dir']}/wlp/usr", serverName)
    config.httpEndpoint.host = "*"
    config.httpEndpoint.httpPort = "8080"
    if config.modified
      config.save(node['wlp']['user'], node['wlp']['group'])
      notifies_delayed(:restart, resources(:service => "wlp-#{serverName}"))
    end
  end
end

# start service
wlp_server serverName do
  action :start
end
