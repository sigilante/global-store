  ::  /sur/global-store.hoon
::::  ~lagrev-nocfep
::    Version ~2023.7.28
::
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
  $%  [%let =desk]
      [%lie =desk]
      [%put =desk =key =value]
      [%del =desk =key]
      [%mode =desk =arena =perm]
      [%enroll =desk wut=?(=ship =arena) =perm]
      [%unroll =desk wut=?(=ship =arena)]
      [%lockdown =desk]
  ==
+$  update
  $%  [%desk (unit (map key value))]
      [%value (unit value)]
  ==
--
