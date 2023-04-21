  ::  %global-store
::::
::    a simple key-value storage solution for ship-global values
::    with a straightforward permissions model
::
/+  *mip
|%
+$  key    path
+$  value  cage
+$  perm   (unit ?(%r %w))
+$  arena  ?(%moon %orbit %public)
+$  whom   ?((unit ship) arena)
::
+$  store  (axal value)
+$  roll   (axal perm)
::
+$  action
  $%  [%put =desk =key =value]
      [%del =desk =key]
      [%lie =desk]
      [%enroll =whom =desk =key =perm]
      [%unroll =whom =desk =key]
      [%lockdown =desk]
  ==
::
+$  update
  $%  [%desk (pair desk ?)]
      [%key p=desk q=(pair key ?)]
      [%value p=value]
  ==
--
