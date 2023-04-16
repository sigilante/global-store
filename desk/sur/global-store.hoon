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
::  XX remove %me?
+$  arena  ?(%public %whitelist %moon %me)
+$  perms  (map arena perm)
+$  whitelist  (set ship)
::
+$  store  (mip =desk =key =value)
::
+$  action
  $%  [%lie =desk]
      [%put =desk =key =value]
      [%del =desk =key]
      [%mode =arena =perm]
      [%whitelist =ship]
      [%whitewash =ship]
      [%lockdown ~]
  ==
+$  update
  $%  [%desk (unit (map key value))]
      [%value (unit value)]
  ==
--
