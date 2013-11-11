include_recipe "wlp::default"

jenkins_war_uri = "http://mirrors.jenkins-ci.org/war/latest/jenkins.war"

jenkins_war_file = "#{Chef::Config[:file_cache_path]}/jenkins.war"
remote_file jenkins_war_file do
  source jenkins_war_uri
  user node[:wlp][:user]
  group node[:wlp][:group] 
  action :create_if_missing
end

server_name = "jenkins"

wlp_server server_name do
  config ({
            "featureManager" => {
              "feature" => [ "jsp-2.2", "appSecurity-2.0" ]
            },
            "httpEndpoint" => {
              "id" => "defaultHttpEndpoint",
              "host" => "*",
              "httpPort" => "9080",
              "httpsPort" => "9443"
            },
            "webApplication" => {
              "location" => jenkins_war_file,
              "application-bnd" => {
                "security-role" => {
                  "name" => "admin",
                  "user" => {
                    "name" => "jenkins-admin"
                  },
                  "group" => {
                    "name" => "jenkins-admins"
                  }
                }
              }
            },
            "basicRegistry" => {
              "realm" => "jenkins",
              "user" => {
                "name" => "jenkins-admin",
                "password" => lambda { Liberty::SecurityHelper.new(node).encode("secret") }
              },
              "group" => {
                "name" => "jenkins-admins",
                "member" => {
                  "name" => "jenkins-admin"
                }
              }
            }
          })
  action :create
end

wlp_jvm_options "set jvm.options for #{server_name}" do
  server_name server_name
  options [ "-Xmx512m" ]
  action :set
end

wlp_server server_name do
  action :start
end
