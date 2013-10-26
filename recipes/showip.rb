# Uses the WebSphere Liberty application cookbook to create
# a Liberty server and install the showip web application.
# Showip is a simple JSP that displays the IP address of the server

cookbook_file "/tmp/showip.war" do
  backup false
  source "showip.war"
  action :create_if_missing
end

application "showip" do

  repository "/tmp/showip.war"
  path "/usr/local/showip"
  scm_provider Chef::Provider::File::Deploy
  owner "wlp"
  group "wlp-admin"

  wlp_application do
    server_name "showip"
    features [ "jsp-2.2", "servlet-3.0" ]
  end

end

# start server if it is not running already
wlp_server "showip" do
  action :start
end


