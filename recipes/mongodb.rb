install_sample "mongodb" do
  location "product/mongodb/mongoDBSample.jar"
  server_name "mongoDBSample"
end

include_recipe "mongodb"
