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

name             'cutlery'
maintainer       'Peter Donald'
maintainer_email 'peter@realityforge.org'
license          'Apache-2.0'
description      'Cutlery is a cookbook containing a collection useful library code.'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.3.0'

issues_url 'https://github.com/realityforge/chef-cutlery/pulls'
source_url 'https://github.com/realityforge/chef-cutlery'
chef_version '>= 12.0' if respond_to?(:chef_version)

supports 'debian'
supports 'ubuntu'
