require 'xml/libxml'
require 'uri'
require 'net/http'

module Fabulator
  GEO_NS = "http://dh.tamu.edu/ns/fabulator/geo/1.0#"
  YAHOO_MAP_API = "http://local.yahooapis.com/MapsService/V1/"
  module Geo
    @@yahoo_api_key = nil

    def self.yahoo_api_key=(k)
      @@yahoo_api_key = k
    end

    def self.yahoo_api_key
      @@yahoo_api_key
    end

    module Actions
      class Lib
        include Fabulator::ActionLib

        register_namespace GEO_NS

        @@geocode_cache = { }

        register_type 'coding', {
          :to => [
            { :type => [ FAB_NS, 'string' ],
              :weight => 1.0,
              :convert => lambda { |x| x.anon_node(x.value.to_s, [ FAB_NS, 'stri
ng' ]) }
            }
          ],
          :from => [
            { :type => [ FAB_NS, 'string' ],
              :weight => 1.0,
              :convert => lambda { |x| encode(x) }
            }
          ],
        }

        @@GeoCodeInfo = {
          'latitude'  => '/y:ResultSet/y:Result/y:Latitude',
          'longitude' => '/y:ResultSet/y:Result/y:Longitude',
          'address'   => '/y:ResultSet/y:Result/y:Address',
          'city'      => '/y:ResultSet/y:Result/y:City',
          'territory' => '/y:ResultSet/y:Result/y:State',
          'postal'    => '/y:ResultSet/y:Result/y:Zip',
          'country'   => '/y:ResultSet/y:Result/y:Country',
        }

        def self.encode(a)
          # Call the YAHOO API to geocode the address
          # for now, we expect simple strings
          if(!@@geocode_cache[a.to_s])
            appid = Fabulator::Geo.yahoo_api_key 
            url = URI.parse(YAHOO_MAP_API + "geocode")
            res = Net::HTTP.start(url.host, url.port) {|http|
              http.get(url.path + "?appid=#{URI.encode(appid)}&location=#{URI.encode(a.to_s)}")
            }
            begin
              res.value
              @@geocode_cache[a.to_s] = res.body
            rescue
            end
          end
          body = @@geocode_cache[a.to_s]
          doc = LibXML::XML::Document.string(body)
          # ns: URN:YAHOO:API
          # /ERROR == unable to do request
          # ns: urn:yahoo:maps
          # /ResultSet/Result/ :
          if(doc.root.namespaces.namespace.to_s == "urn:yahoo:maps" && doc.root.name.to_s == "ResultSet") 
            info = a.anon_node(nil, [ GEO_NS, 'coding' ])
            info.value = a.to_s
            v = doc.find("/y:ResultSet/y:Result/@precision", "y:urn:yahoo:maps")
            if(v.length > 0)
              info.create_child('precision', v.first.value)
            end
            @@GeoCodeInfo.each_pair do |nom, path|
              v = doc.find(path, 'y:urn:yahoo:maps')
              if(v.length > 0) 
                info.create_child(nom, v.first.content)
              end
            end
            return info
          end
          nil
        end
      end
    end
  end
end
