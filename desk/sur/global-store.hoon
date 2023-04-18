  ::  global-store.hoon
::::
::    a simple key-value storage solution for ship-global values
::    with a straightforward permissions model
::
/+  *mip
|%
+$  key    @tas
+$  value  vase
+$  perm   (unit ?(%r %w))
+$  arena  ?(%moon %public)
::
+$  store  (mip desk key value)
+$  roll   (mip desk ?(ship arena) perm)
::
+$  action
  $%  [%put =desk =key =value]
      [%del =desk =key]
      [%lie =desk]
      [%enroll =desk wut=?(ship arena) =perm]
      [%unroll =desk wut=?(ship arena)]
      [%lockdown =desk]
  ==
+$  update
  $%  [%desk res=(unit (map key value))]
      [%value res=(unit value)]
  ==
--
