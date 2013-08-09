# Cookbook Name:: wlp-samples
# Attributes:: default
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and

require "rexml/document"

module LibertySamples
  class Configuration
    
    attr_accessor :doc
    attr_accessor :modified

    def initialize(utils, serverName, doc)
      @utils = utils
      @serverName = serverName
      @doc = doc
      @modified = false
    end

    def self.load(node, serverName)
      utils = Liberty::Utils.new(node)
      serverXml = "#{utils.serversDirectory}/#{serverName}/server.xml"
      f = File.open(serverXml)
      doc = REXML::Document.new(f)
      f.close
      return Configuration.new(utils, serverName, doc)
    end

    def httpEndpoint(id = "defaultHttpEndpoint")
      return HttpEndpoint.new(self, id)
    end

    def save()
      serverXmlNew = "#{@utils.serversDirectory}/#{@serverName}/server.xml.new"
      out = File.open(serverXmlNew, "w")
      formatter = REXML::Formatters::Default.new
      formatter.write(@doc, out)
      out.close

      @utils.chown(serverXmlNew)

      serverXml = "#{@utils.serversDirectory}/#{@serverName}/server.xml"
      FileUtils.mv(serverXmlNew, serverXml)
    end

  end

  class HttpEndpoint

    def initialize(parent, id)
      @parent = parent
      
      @httpEndpoint = @parent.doc.root.elements["httpEndpoint[@id='#{id}']"]
      if ! @httpEndpoint 
        @httpEndpoint = REXML::Element.new("httpEndpoint")
        @httpEndpoint.attributes["id"] = id
        @parent.doc.root << @httpEndpoint
        @parent.modified = true
      end
    end

    def httpPort
      return @httpEndpoint.attributes["httpPort"]
    end

    def httpPort=(value)
      setAttribute("httpPort", value)
    end

    def httpsPort
      return @httpEndpoint.attributes["httpsPort"]
    end

    def httpsPort=(value)
      setAttribute("httpsPort", value)
    end

    def host
      return @httpEndpoint.attributes["host"]
    end

    def host=(value)
      setAttribute("host", value)
    end

    private

    def setAttribute(name, value)
      currentValue = @httpEndpoint.attributes[name]
      if currentValue == value
        # nothing to do
      else
        @httpEndpoint.attributes[name] = value
        @parent.modified = true
      end
    end
  end

end

