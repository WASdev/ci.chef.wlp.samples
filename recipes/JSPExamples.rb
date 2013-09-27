application "JSPExamples" do

  repository "http://central.maven.org/maven2/org/apache/geronimo/samples/jsp-examples-war/3.0-M1/jsp-examples-war-3.0-M1.war"
  path "/usr/local/JSPExamples"
  scm_provider Chef::Provider::RemoteFile::Deploy
  owner "wlp"
  group "wlp-admin"

  wlp_application do
    server_name "JSPExamples"
    features [ "jsp-2.2", "servlet-3.0" ]
  end

end

# start server if it is not running already
wlp_server server_name do
  action :start
end


