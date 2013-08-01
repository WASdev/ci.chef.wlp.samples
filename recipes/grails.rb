serverName = "GrailsSample"

install_sample "grails" do
  location "osi/grails/GrailsSample.jar"
  server_name serverName
end

wlp_server serverName do
  action :start
end
