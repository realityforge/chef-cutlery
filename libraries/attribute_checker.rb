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
        puts "WARNING: Invoking deprecated Chef::AttributeChecker.ensure_attribute - use RealityForge::AttributeTools.ensure_attribute instead."
        RealityForge::AttributeTools.ensure_attribute(root_element, key, type, prefix)
      end
    end
  end
end
