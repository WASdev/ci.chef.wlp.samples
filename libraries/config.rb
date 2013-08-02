require "rexml/document"

module Liberty
  class Configuration
    
    attr_accessor :doc
    attr_accessor :modified

    def initialize(userDir, serverName, doc)
      @userDir = userDir
      @serverName = serverName
      @doc = doc
      @modified = false
    end

    def self.load(userDir, serverName)
      serverXml = "#{userDir}/servers/#{serverName}/server.xml"
      f = File.open(serverXml)
      doc = REXML::Document.new(f)
      f.close
      return Configuration.new(userDir, serverName, doc)
    end

    def feature
      return FeatureManager.new(self)
    end

    def featureManager
      return FeatureManager.new(self)
    end

    def httpEndpoint(id = "defaultHttpEndpoint")
      return HttpEndpoint.new(self, id)
    end

    def save(user = nil, group = nil)
      serverXmlNew = "#{@userDir}/servers/#{@serverName}/server.xml.new"
      out = File.open(serverXmlNew, "w")
      formatter = REXML::Formatters::Default.new
      formatter.write(@doc, out)
      out.close

      FileUtils.chown(user, group, serverXmlNew)

      serverXml = "#{@userDir}/servers/#{@serverName}/server.xml"
      FileUtils.mv(serverXmlNew, serverXml)
    end

  end

  class FeatureManager

    def initialize(parent)
      @parent = parent
      
      @featureManager = @parent.doc.root.elements["featureManager"]
      if ! @featureManager 
        @featureManager = REXML::Element.new("featureManager")
        @parent.doc.root << @featureManager
        @parent.modified = true
      end
    end
    
    def + (val)
      if findFeature(val)
        # nothing to do
      else
        addFeature(val)
      end

    end

    def - (val)
      feature = findFeature(val)
      if feature
        @featureManager.delete_element(feature)
        @parent.modified = true
      else
        # feature not found
      end
    end

    private 

    def findFeature(featureName)
      @featureManager.elements.each("feature") do | feature |
        if featureName == feature.text
          return feature
        end
      end
      return nil
    end

    def addFeature(featureName)
      feature = REXML::Element.new("feature")
      feature.text = featureName
      @featureManager << feature
      @parent.modified = true
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

