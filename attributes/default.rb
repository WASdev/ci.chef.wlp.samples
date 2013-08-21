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
  "enabled" => true,
  "servername" => "WicketSample",
  "description" => "Wicket Sample Server",
  "features" => [ "servlet-3.0", "jsp-2.2" ],
  "httpendpoints" => [
    {
      "id" => "defaultHttpEndpoint",
      "host" => "*",
      "httpport" => "9080",
      "httpsport" => "9443"
    }
  ],
  "includes" => [ "${shared.config.dir}/WicketSampleApp.xml" ]
}
