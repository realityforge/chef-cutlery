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
  module SearchBlender #nodoc
    class << self
      # Search an index on the chef server, using a particular search query. For each result returned,
      # extract the data from the input path in the result and deep merge data into the output path of the node
      # using the override priority.
      #
      # = Parameters
      # * +node+:: The node into which the results will be deep merged.
      # * +search_key+:: The name of the index that is searched on the chef server.
      # * +query+:: The query to use when searching the index.
      # * +input_path+:: The path to traverse in the search result. The path elements are separated using a '.' character.
      # * +output_path+:: The path on the node on which to deep merge the results.
      # * +options+:: The set of optional parameters to pass. Currently only the 'sort' key is used and it defaults to 'X_CHEF_id_CHEF_X asc'.
      def blend_search_results_into_node(node, search_key, query, input_path, output_path, options = {})
        sort_key = options['sort'] || 'X_CHEF_id_CHEF_X asc'
        partial_search_keys = {'output' => input_path.split('.')}

        ::Chef::PartialSearch.new.search(search_key, query, :keys => partial_search_keys, :sort => sort_key) do |config|
          RealityForge::AttributeTools.deep_merge(node, output_path, config['output'])
        end
      end
    end
  end
end
