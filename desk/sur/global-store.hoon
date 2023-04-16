  ::  global-store.hoon
::::
::    a simple key-value storage solution for ship-global values
::    with a straightforward permissions model
::
/+  *mip
|%
+$  key    @tas
+$  value  vase
+$  perm  (unit ?(%r %w))
+$  arena  ?(%moon %public)
::
+$  store      (mip =desk =key =value)
+$  perms      (map [=desk =arena] =perm)
+$  whitelist  (map [=desk =ship] =perm)
::
+$  action
  $%  [%lie =desk]
      [%put =desk =key =value]
      [%del =desk =key]
      [%mode =desk =arena =perm]
      [%whitelist =desk =ship =perm]
      [%whitewash =desk =ship]
      [%lockdown =desk]
  ==
+$  update
  $%  [%desk (unit (map key value))]
      [%value (unit value)]
  ==
--
