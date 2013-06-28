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
      # * +root_element+:: The root element used to base lookup on. Often a node element.
      # * +key+:: The path to lookup.
      # * +type+:: The expected type of the value, Set to nil to ignore type checking.
      # * +prefix+:: The prefix already traversed to get to root.
      def ensure_attribute(root_element, key, type = nil, prefix = nil)
        key_parts = key.split('.')
        output_entry = key_parts[0...-1].inject(root_element) { |element, k| element[k] }
        value = output_entry ? output_entry[key_parts.last] : nil
        label = prefix ? "#{prefix}.#{key}" : key
        raise "Attribute '#{label}' is missing" unless value
        raise "The value of attribute '#{label}' is '#{value.inspect}' and this is not of the expected type #{type.inspect}" if type && !value.is_a?(type)
        value
      end
    end
  end
end
