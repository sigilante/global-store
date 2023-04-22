  ::  %global-store
::::
::    a simple key-value storage solution for ship-global values
::    with a straightforward permissions model
::
|%
+$  key    path
+$  value  cage
+$  perm   (unit ?(%r %w))
+$  arena
  $%  [%moon ~]
      [%orbit ~]
      [%public ~]
      [%ship =ship]
  ==
::
+$  store  (axal value)
+$  roll   (axal perm)
::
+$  action
  $%  [%put =desk =key =value]
      [%del =desk =key]
      [%lop =desk =key]
      [%enroll =arena =perm =desk =key]
      [%unroll =arena =desk =key]
      [%lockdown =desk =key]
  ==
::
+$  update
  $%  [%key p=desk q=key r=?]
      [%value p=(unit value)]
  ==
--
