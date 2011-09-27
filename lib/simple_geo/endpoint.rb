module SimpleGeo
  class Endpoint

    class << self
      def feature(id)
        endpoint_url "features/#{id}.json"
      end

      def get_layers()
        endpoint_url "layers.json"
      end

      def get_layer_info(layer)
        endpoint_url "layers/#{layer}.json"
      end

      def record(layer, id)
        endpoint_url "records/#{layer}/#{id}.json"
      end

      def records(layer, ids)
         ids = ids.join(',')  if ids.is_a? Array
         endpoint_url "records/#{layer}/#{ids}.json"
      end

      def add_records(layer)
        endpoint_url "records/#{layer}.json"
      end

      def history(layer, id)
        endpoint_url "records/#{layer}/#{id}/history.json"
      end

      def nearby_geohash(layer, geohash)
        endpoint_url "records/#{layer}/nearby/#{geohash}.json"
      end

      def nearby_coordinates(layer, lat, lon, radius=nil)
        path = "records/#{layer}/nearby/#{lat},#{lon}.json"
        path = "#{path}?radius=#{radius}" if radius
        endpoint_url path
      end

      def nearby_ip_address(layer, ip, radius=nil)
        path = "records/#{layer}/nearby/#{ip}.json"
        path = "#{path}?radius=#{radius}" if radius
        endpoint_url path
      end

      def nearby_address(layer, address, radius=nil)
        path = "records/#{layer}/nearby/address.json?address=#{address}"
        path = "#{path}&radius=#{radius}" if radius
        endpoint_url path
      end

      def context(lat, lon, filter)
        if filter
          endpoint_url "context/#{lat},#{lon}.json?filter=#{filter}"
        else
          endpoint_url "context/#{lat},#{lon}.json"
        end
      end
      
      def context_by_table(lat, lon, table)
        endpoint_url "context/#{lat},#{lon}.json?demographics.acs__table=#{table}"
      end
      
      def context_by_address_and_table(address, table)
        endpoint_url "context/address.json?address=#{address}&demographics.acs__table=#{table}"
      end
            
      def context_by_address(address, filter)
        if filter
          endpoint_url "context/address.json?address=#{address}&filter=#{filter}"
        else
          endpoint_url "context/address.json?address=#{address}"
        end
      end

      def context_ip(ip, filter)
        if filter
          endpoint_url "context/#{ip}.json?filter=#{filter}"
        else
          endpoint_url "context/#{ip}.json"
        end
      end

      def geocode_from_ip(ip)
        endpoint_url "context/#{ip}.json?filter=query"
      end

      def places(lat, lon, options)
        if options.empty?
          endpoint_url "places/#{lat},#{lon}.json"
        else
          params = []
          options.each do |k,v|
            #allow for multiple category filtering
            if k.eql?(:category)
              v.split(",").each do |cat|
                value = CGI.escape(cat.strip.to_s)
                params << "#{k}=#{value}"
              end
            else
              params << "#{k}=#{CGI.escape(v.to_s)}"
            end

          end
          endpoint_url "places/#{lat},#{lon}.json?#{params.join("&")}"
        end
      end

      def places_by_address(address, options)
        address = CGI.escape(address.strip.to_s)
        if options.empty?
          endpoint_url "places/address.json?address=#{address}"
        else
          params = []
          params << "address=#{address}"
          options.each do |k,v|
            #allow for multiple category filtering
            if k.eql?(:category)
              v.split(",").each do |cat|
                value = CGI.escape(cat.strip.to_s)
                params << "#{k}=#{value}"
              end
            else
              params << "#{k}=#{CGI.escape(v.to_s)}"
            end
          end
          endpoint_url "places/address.json?#{params.join("&")}"
        end
      end

      def places_by_ip(ip, options)
        if options.empty?
          endpoint_url "places/#{ip}.json"
        else
          params = []
          options.each do |k,v|
            #allow for multiple category filtering
            if k.eql?(:category)
              v.split(",").each do |cat|
                value = CGI.escape(cat.strip.to_s)
                params << "#{k}=#{value}"
              end
            else
              params << "#{k}=#{CGI.escape(v.to_s)}"
            end
          end
          endpoint_url "places/#{ip}.json?#{params.join("&")}"
        end
      end

      def endpoint_url(path, version='1.0')
        [REALM, version, path].join('/')
      end
    end

  end

end
