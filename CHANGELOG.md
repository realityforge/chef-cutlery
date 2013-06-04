## 0.2.6:

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
