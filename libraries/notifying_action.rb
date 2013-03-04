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

# Essentially invoke the action block in a separate run context and if any resources are modified within
# the sub context then mark this node as updated.
#
# See http://realityforge.org/code/2012/07/17/lwrp-notify-on-changed-resources.html for motivation and explanation.
class Chef
  class Provider
    class << self
      def notifying_action(key, &block)
        action key do
          # So that we can refer to these within the sub-run-context block.
          cached_new_resource = new_resource
          cached_current_resource = current_resource

          # Setup a sub-run-context.
          sub_run_context = @run_context.dup
          sub_run_context.resource_collection = Chef::ResourceCollection.new

          # Declare sub-resources within the sub-run-context. Since they are declared here,
          # they do not pollute the parent run-context.
          begin
            original_run_context, @run_context = @run_context, sub_run_context
            instance_eval(&block)
          ensure
            @run_context = original_run_context
          end

          # Converge the sub-run-context inside the provider action.
          # Make sure to mark the resource as updated-by-last-action if any sub-run-context
          # resources were updated (any actual actions taken against the system) during the
          # sub-run-context convergence.
          begin
            Chef::Runner.new(sub_run_context).converge
          ensure
            if sub_run_context.resource_collection.any?(&:updated?)
              new_resource.updated_by_last_action(true)
            end
          end
        end
      end
    end
  end
end
