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
+$  whom   ?(ship arena)
::
+$  store  (mip desk key value)
+$  roll   (mip desk whom perm)
::
+$  action
  $%  [%put =desk =key =value]
      [%del =desk =key]
      [%lie =desk]
      [%enroll =desk =whom =perm]
      [%unroll =desk =whom]
      [%lockdown =desk]
  ==
::
+$  update
  $%  [%desk res=(unit (map key value))]
      [%value res=(unit value)]
  ==
--
