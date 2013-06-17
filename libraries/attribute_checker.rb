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
  module AttributeChecker #nodoc
    class << self
      # Ensure attribute is present.
      #
      # = Parameters
      # * +node+:: The node into which the results will be set.
      # * +key+:: The path on the node on which to set value.
      def ensure_attribute(node, key)
        key_parts = key.split('.')
        output_entry = key_parts[0...-1].inject(node.override) { |element, k| element[k] }
        raise "Missing config #{key}" unless output_entry[key_parts.last]
      end
    end
  end
end
