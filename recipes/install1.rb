# Install the helloworld application
# TODO: use app from wasdev

application "HelloworldApp" do

  path "/usr/local/helloworldApp"
  repository "http://central.maven.org/maven2/org/apache/tuscany/sca/samples/helloworld-webapp/2.0/helloworld-webapp-2.0.war"
  scm_provider Chef::Provider::RemoteFile::Deploy

  wlp_application do
    server_name "Test1"
    features [ "jsp-2.2", "servlet-3.0" ]
  end

end

