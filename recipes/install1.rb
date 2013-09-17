# Install the helloworld application
# TODO: use app from wasdev

serverName = "Test1"

application "HelloworldApp2" do

  path "/usr/local/helloworldApp"
  repository "http://central.maven.org/maven2/org/apache/tuscany/sca/samples/helloworld-webapp/2.0/helloworld-webapp-2.0.war"
  scm_provider Chef::Provider::RemoteFile::Deploy
  owner "wlp"
  group "wlp-admin"

  wlp_application do

    server_name serverName

    features [ "jsp-2.2", "servlet-3.0" ]

#   application name and location default to above "HelloworldApp" and path
#   config other application attributes via attributes here, eg:
#      application_type "war"
#      application_location "/some/file"
#      application_context_root "someroot"
#      application_auto_start "true"
#   or, to use a custom xml template from this cookbook:
#    application_xml_template "HelloworldApp.xml.erb"

  end

  wlp do
    server_name serverName
  end

end
