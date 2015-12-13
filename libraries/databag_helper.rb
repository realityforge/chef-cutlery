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
  module Databag #nodoc
    class << self

      # Simplified mechanism for loading data bag item with some reasonable error handling
      def load_data_bag(databag_name, item_id)
        begin
          Chef::DataBagItem.load(databag_name, item_id)
        rescue Net::HTTPServerException
          raise "Unable to locate data bag item #{databag_name}[#{item_id}]"
        end
      end

      # Simplified mechanism for loading data bag item with some reasonable error handling
      def databag_path_prefix(databag_name, item_id)
        "databag.#{databag_name}.#{item_id}"
      end
    end
  end
end
