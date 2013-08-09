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
    config = LibertySamples::Configuration.load(node, serverName)
    config.httpEndpoint.host = node["wlp-samples"]["grails"]["host"] || node["wlp-samples"]["host"]
    config.httpEndpoint.httpPort = node["wlp-samples"]["grails"]["httpPort"]
    if config.modified
      config.save()
      notifies_delayed(:restart, resources(:service => "wlp-#{serverName}"))
    end
  end
end

# start service
wlp_server serverName do
  action :start
end
