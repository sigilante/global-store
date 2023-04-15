  ::  global-store.hoon
::::
::    a simple key-value storage solution for ship-global values
::    with a straightforward permissions model
::
/+  *mip
|%
+$  key    @tas
+$  value  vase
+$  perm
  $~  %$
  ?(%w %r %$)
+$  arena  ?(%public %whitelist %moon %me)
+$  perms  (map arena perm)
+$  whitelist  (set ship)
::
+$  store  (mip =desk =key =value)
::
+$  action
  $%  [%let =desk]
      [%lie =desk]
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
