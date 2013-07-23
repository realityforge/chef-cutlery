## 0.2.7:

* Add utility method RealityForge::SearchTools.search_and_deep_merge
  to merge a search result into a hash and return it.
* Support a get_attribute helper method on RealityForge::AttributeTools
* Add support for passing Mash instances into deep_merge and
  ensure_attribute methods of RealityForge::AttributeTools
* Add support for setting values into Mash values via
  `RealityForge::AttributeTools.set_attribute` and deprecate
  `RealityForge::AttributeTools.set_attribute_on_node`.

## 0.2.6:

* Extract attribute related helpers into the class
  RealityForge::AttributeTools and deprecate the old versions.
* Add a utility method to ensure attributes are present. i.e.
  `Chef::AttributeChecker.ensure_attribute(node, 'iris.version')`
* Add a utility class for accessing configuration for "services".
  Useful for storing configuration in a node or data bags as a
  poor mans service registry.
* Update `Chef::SearchBlender.blend_search_results_into_node`
  to use partial search where available.

## 0.2.2:

* Add utility method to blend attribute value into path via
  `Chef::AttributeBlender.blend_attribute_into_node`

## 0.2.1:

* Chef 11 compatibility fixes.

## 0.2.0:

* Declare the notifying_action as part of a provider as the method should only
  be used in LWRPs. This avoid polluting the Object class with unnecessary methods.

## 0.1.0:

* Initial release.
