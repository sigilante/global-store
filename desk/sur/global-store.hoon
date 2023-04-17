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
+$  store  (mip =desk =key =value)
+$  roll   (map [=desk ?(=ship =arena)] =perm)
::
+$  action
  $%  [%lie =desk]
      [%put =desk =key =value]
      [%del =desk =key]
      [%mode =desk =arena =perm]
      [%enroll =desk =ship =perm]
      [%unroll =desk =ship]
      [%lockdown =desk]
  ==
+$  update
  $%  [%desk (unit (map key value))]
      [%value (unit value)]
  ==
--
