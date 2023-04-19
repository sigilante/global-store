  ::  global-store.hoon
::::
::    a simple key-value storage solution for ship-global values
::    with a straightforward permissions model
::
/+  *mip
|%
+$  keep   @tas
+$  key    @tas
+$  value  vase
+$  perm   (unit ?(%r %w))
+$  arena  ?(%moon %orbit %public)
+$  whom   ?(ship arena)
::
+$  store  (mip keep key value)
+$  roll   (mip keep whom perm)
::
+$  action
  $%  [%put =keep =key =value]
      [%del =keep =key]
      [%lie =keep]
      [%enroll =keep =whom =perm]
      [%unroll =keep =whom]
      [%lockdown =keep]
  ==
::
+$  update
  $%  [%keep res=(unit (map key value))]
      [%value res=(unit value)]
  ==
--
