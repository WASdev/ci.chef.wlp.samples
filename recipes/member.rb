# Recipe that demonstrates how to join a server to a Liberty collective

serverName = "memberD"

# define service beforehand - otherwise notifications from ruby_block won't work
service "wlp-#{serverName}" do
  supports :start => true, :restart => true, :stop => true, :status => true
  action :nothing
end

wlp_server serverName do
  config ({
            "featureManager" => {
              "feature" => [ "jsp-2.2", "clusterMember-1.0" ]
            },

            # this overrides the defaultCluster name 
            "clusterMember" => {
              "name" => [ "myTestCluster" ]
            },

            # this enables application and packages deploys from the collective 
            "remoteFileAccess" => {
              "writeDir" => [ "${server.config.dir}" ]
            },

            "include" => {
              # this file is created by the wlp_collective join
              "location" => "${server.config.dir}/collective-join-include.xml"
            },

            "httpEndpoint" => {
              "id" => "defaultHttpEndpoint",
              "host" => "*",
              "httpPort" => "9089",
              "httpsPort" => "9452"
            }
          })
  action :create
end

# join the server to the collective
wlp_collective "#{serverName}" do
   action :join
   server_name serverName
   # the following are the details of the collective controller 
   host "localhost"
   port "9443"
   user "admin"
   password "adminpwd"
   keystorePassword "Liberty"
end

# start service
wlp_server serverName do
  action :start
end
