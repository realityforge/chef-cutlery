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

class RealityForge #nodoc
  module AttributeTools #nodoc
    class << self
      # Deep merge value into node using output path. If the value provided is nil then perform operation.
      #
      # = Parameters
      # * +root_element+:: The node or mash into which the results will be deep merged.
      # * +output_path+:: The path on the node on which to deep merge the results.
      # * +value+:: The value to merge.
      def deep_merge(root_element, output_path, value)
        if value
          existing =
            output_path.nil? ?
              root_element :
              output_path.split('.').inject(root_element.respond_to?(:override) ? root_element.override : root_element) { |element, k| element.nil? ? nil : element[k] }
          if existing
            results = ::Chef::Mixin::DeepMerge.deep_merge(value, existing).to_hash
          else
            results = value.dup
          end
          set_attribute(root_element, output_path, results)
        end
      end

      # Ensure attribute is present.
      #
      # = Parameters
      # * +root_element+:: The root element used to base lookup on. Often a node element.
      # * +key+:: The path to lookup.
      # * +type+:: The expected type of the value, Set to nil to ignore type checking.
      # * +prefix+:: The prefix already traversed to get to root.
      def ensure_attribute(root_element, key, type = nil, prefix = nil)
        value = get_attribute(root_element, key, type, prefix)
        label = prefix ? "#{prefix}.#{key}" : key
        raise "Attribute '#{label}' is missing" unless value
        value
      end

      # Get attribute if present.
      #
      # = Parameters
      # * +root_element+:: The root element used to base lookup on. Often a node element.
      # * +key+:: The path to lookup.
      # * +type+:: The expected type of the value, Set to nil to ignore type checking.
      # * +prefix+:: The prefix already traversed to get to root.
      def get_attribute(root_element, key, type = nil, prefix = nil)
        key_parts = key.split('.')
        output_entry = key_parts[0...-1].inject(root_element.to_hash) { |element, k| element.nil? ? nil : element[k] }
        return nil unless output_entry
        value = output_entry[key_parts.last]
        return nil unless value
        label = prefix ? "#{prefix}.#{key}" : key
        raise "The value of attribute '#{label}' is '#{value.inspect}' and this is not of the expected type #{type.inspect}" if type && !value.is_a?(type)
        value
      end


      # Set attribute value on mash using a path. If the element is a node then use override priority.
      #
      # = Parameters
      # * +element+:: The mash/node into which the results will be set.
      # * +key+:: The path on the node on which to set value.
      # * +value+:: The value to set.
      def set_attribute(root_element, key, value)
        key_parts = key.nil? ? [] : key.split('.')
        base = root_element.respond_to?(:override) ? root_element.override : root_element
        output_entry = key_parts[0...-1].inject(base) { |element, k| element[k] }
        output_entry[key_parts.last] = value
      end

      # Set attribute value on node using a path.
      #
      # = Parameters
      # * +node+:: The node into which the results will be set.
      # * +key+:: The path on the node on which to set value.
      # * +value+:: The value to set.
      def set_attribute_on_node(node, key, value)
        puts "WARNING: Invoking deprecated RealityForge::AttributeTools.set_attribute_on_node - use RealityForge::AttributeTools.set_attribute instead."
        set_attribute(node, key, value)
      end
    end
  end
end
