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
  module AttributeBlender #nodoc
    class << self
      # Set a node on an attribute using a .
      #
      # = Parameters
      # * +node+:: The node into which the results will be set.
      # * +key+:: The path on the node on which to set value.
      # * +value+:: The value to set.
      def blend_attribute_into_node(node, key, value)
        key_parts = key.split('.')
        output_entry = key_parts[0...-1].inject(node.override) { |element, k| element[k] }
        output_entry[key_parts.last] = value
      end
    end
  end
end
