  ::  %global-store
::::
::    a simple key-value storage solution for ship-global values
::    with a straightforward permissions model
::
/+  *mip
|%
+$  key    path
+$  value  (unit cage)
+$  perm   (unit ?(%r %w))
+$  arena  ?(%moon %orbit %public)
+$  whom   ?(ship arena)
::
+$  store  (axal value)
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
  $%  [%desk (pair desk ?)]
      [%key p=desk q=(pair key ?)]
      [%value p=value]
  ==
--
