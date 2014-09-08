# Recipe that demonstrates how to create a Liberty collective controller

serverName = "#{node['wlp']['collectiveServerName']}"

# define service beforehand - otherwise notifications from ruby_block won't work
service "wlp-#{serverName}" do
  supports :start => true, :restart => true, :stop => true, :status => true
  action :nothing
end

wlp_server serverName do
  config ({
            "featureManager" => {
              "feature" => [ "adminCenter-1.0" ]
            },

            # this file is created by the wlp_collective create
            "include" => {
              "location" => "${server.config.dir}/controller.xml"
            },
            "httpEndpoint" => {
              "id" => "defaultHttpEndpoint",
              "host" => "*",
              "httpPort" => "9080",
              "httpsPort" => "9443"
            }
          })
  action :create
end

wlp_collective "#{serverName}" do
   action :create
   server_name serverName
   keystorePassword "Liberty"
   admin_user "admin"
   admin_password "adminpwd"
end

# start service
wlp_server serverName do
  action :start
end
