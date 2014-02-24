# Cookbook Name:: wlp-samples
# Attributes:: default
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and

default["wlp-samples"]["host"] = "*"

default["wlp-samples"]["grails"]["httpPort"] = 9102

default[:wlp][:servers][:WicketSample] = {
  "enabled" => false,
  "servername" => "WicketSample",
  "description" => "Wicket Sample Server",
  "features" => [ "servlet-3.0", "jsp-2.2" ],
  "httpEndpoints" => [
    {
      "id" => "defaultHttpEndpoint",
      "host" => "*",
      "httpPort" => "9080"
    }
  ],
  "includes" => [ "${shared.config.dir}/WicketSampleApp.xml" ]
}

default["wlp-samples"]["proxy"]["clusterName"] = "MYCLUSTER1"
default["wlp-samples"]["proxy"]["clusterNetworkInterface"] = "eth0"

