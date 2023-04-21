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
      [%lop =desk =key]
      [%enroll =whom =desk =key =perm]
      [%unroll =whom =desk =key]
      [%lockdown =desk =key]
  ==
::
+$  update
  $%  [%desk (pair desk ?)]
      [%key p=desk q=(pair key ?)]
      [%value p=value]
  ==
--
