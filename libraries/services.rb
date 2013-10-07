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
# limitations under the License.
#

class Chef #nodoc
  module Services #nodoc
    class << self
      # Register a service configuration on the node.
      #
      # = Parameters
      # * +node+:: The node into which the results will be set.
      # * +key+:: The symbolic name of the service.
      # * +value+:: The service configuration data.
      def register(node, key, value, options = {})
        service_type = options[:type] || 'services'
        RealityForge::AttributeTools.set_attribute(node, "#{service_type}.#{key}", value)
      end

      # Lookup a service configuration.
      # The service configuration is stored as configuration data against a node or
      # in a data bag item. There are various categories of service which define the
      # location to search for configuration in node data or the name of the data bag
      # to look for the configuration.
      #
      # The 'database' service type would look for configuration in the node below the
      # 'database' key. The 'database' service type would also look in the 'database'
      # data bag.
      #
      # The search path for the service configuration is;
      # - look at the current node's attribute data.
      # - search for nodes within the current environment.
      # - search in data bag for item tagged with current environment.
      # - search for nodes within any environment.
      # - search in data bag for item in no environment.
      #
      # = Parameters
      # * +node+:: The node from which to base the search.
      # * +key+:: The symbolic name of the service.
      # * +options+:: Optional configuration to restrict the way search operates.
      #               +:optional+ (true | false) :: If true raise an exception if a service can not be found.
      #               +:type+ (String) :: The service type. Defaults to 'services'.
      #               +:scope+ (:all | :node | :environment) :: If the scope is :environment then the service must be in the same environment, if the scope is :node it must be registered on the same node otherwise it can be anywhere.
      #               +:environment+ (String) :: The environment in which to search for the service. Not allowed if scope = :node.
      def lookup(node, key, options = {})

        service_type = options[:type] || 'services'

        return node[service_type][key].to_hash if node[service_type] && node[service_type][key]

        # Scope defaults to :all, or to :environment if options[:environment] has been supplied
        scope = options[:scope] || ( options[:environment] ? :environment : :all )
        raise "Unknown scope #{scope.inspect}" unless [:environment, :node, :all].include?(scope)
        raise "Scope set to :node and environment has been specified - this doesn't make sense" if ( :node == scope && options[:environment] )

        environment = options[:environment] || node.chef_environment

        unless :node == scope
          partial_search_keys = {'fqdn' => ['fqdn'], key => [service_type, key]}

          result = Chef::PartialSearch.new.search(:node, "#{service_type}_#{key}*:* AND chef_environment:#{environment} AND NOT name:#{node.name}", :keys => partial_search_keys)[0]
          return result[0][key] if 1 == result.length
          raise "Duplicate service of type '#{service_type}' for key '#{key}' registered in environment #{environment}. Found in nodes #{result.collect { |n| n['fqdn'] }}" if result.length > 1

          result = Chef::Search::Query.new.search(service_type, "type:#{key} AND chef_environment:#{environment}")[0]
          return result[0]['config'] if 1 == result.length
          raise "Duplicate service of type '#{service_type}' for key '#{key}' registered in data bag in environment #{environment}. Found in items #{result.collect { |n| n['id'] }}" if result.length > 1

          unless :environment == scope
            result = Chef::PartialSearch.new.search(:node, "#{service_type}_#{key}*:* AND NOT name:#{node.name}", :keys => partial_search_keys)[0]
            return result[0][key] if 1 == result.length
            raise "Duplicate service of type '#{service_type}' for key '#{key}' registered globally. Found in nodes #{result.collect { |n| n['fqdn'] }}" if result.length > 1

            result = Chef::Search::Query.new.search(service_type, "type:#{key} AND NOT chef_environment:*")[0]
            return result[0]['config'] if 1 == result.length
            raise "Duplicate service of type '#{service_type}' for key '#{key}' registered in data bag in environment #{environment}. Found in items #{result.collect { |n| n['id'] }}" if result.length > 1
          end
        end

        raise "Unable to locate service configuration named #{key}" unless options[:optional]
        return nil
      end
    end
  end
end
