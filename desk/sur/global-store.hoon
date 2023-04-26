::    %global-store
::::
  ::  a simple key-value storage solution for ship-global values
::    with a straightforward permissions model
::
|%
+$  key    path
+$  value  cage
+$  perm   (unit ?(%r %w))
+$  arena
  $%  [%moon ~]
      [%orbit ~]
      [%kids ~]
      [%public ~]
      [%ship =ship]
  ==
::
+$  roll   (axal perm)
+$  store  (axal @uvI)
+$  objs   (map @uvI value)
+$  refs   (jug @uvI path)
::
+$  action
  $%  [%put =desk =key =value]
      [%del =desk =key]
      [%lop =desk =key]
    ::
      [%enroll =desk =key =arena =perm]
      [%unroll =desk =key =arena]
      [%lockdown =desk]
    ::
      [%watch =desk =key]
      [%leave =desk =key]
  ==
::
+$  update
  $%  [%key (trel desk key ?)]
      [%value p=(unit value)]
  ==
--
