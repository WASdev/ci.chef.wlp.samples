# Installs and configures the Apache web server as a 
# load balancing proxy for a cluster of Liberty servers.
# The cluster is defined by a Chef role and all nodes
# in that role will be configured as members of the cluster.

  include_recipe "apache2"
  include_recipe "apache2::mod_proxy"
  include_recipe "apache2::mod_proxy_http"
  include_recipe "apache2::mod_proxy_balancer"
  include_recipe "apache2::mod_rewrite"

  #ipaddresses = [ "192.168.33.10", "192.168.1.64", "192.168.1.65"]
  ipaddresses = []

  cluster_name = node["wlp-samples"]["proxy"]["clusterName"]
  cluster_interface = node["wlp-samples"]["proxy"]["clusterNetworkInterface"]
  cluster_nodes = search(:node, "roles:#{cluster_name}")
  cluster_nodes.each do |cluster_node|
     ipaddresses <<  cluster_node["network"]["interfaces"][cluster_interface]["addresses"].select{|address, data| data["family"] == "inet"}.keys[0]
  end

  template "/etc/apache2/conf.d/wlp.conf" do
    source "wlp.conf.erb"
    mode   "0775"
    variables ({
      :clustername => cluster_name,
      :ipaddresses=> ipaddresses
    })

    notifies :restart, "service[apache2]", :delayed

  end
