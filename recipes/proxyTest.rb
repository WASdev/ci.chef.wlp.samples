include_recipe "wlp::default"
wlp_server "iptest" do
  config ({
            "featureManager" => {
              "feature" => [ "jsp-2.2" ]
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

directory "#{node['wlp']['base_dir']}/wlp/usr/servers/iptest/dropins/iptest.war" do
   recursive true
end

cookbook_file "#{node['wlp']['base_dir']}/wlp/usr/servers/iptest/dropins/iptest.war/showip.jsp" do
  backup false
  source "showip.jsp"
  action :create_if_missing
end

wlp_server "iptest" do
  action :start
end
