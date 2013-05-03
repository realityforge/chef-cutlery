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
