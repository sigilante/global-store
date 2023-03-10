  ::  global-store.hoon
::::
::    a simple key-value storage solution for ship-global values
::    with a straightforward permissions model
::
/+  *mip
|%
::
+$  desk   @tas
+$  key    @tas
+$  value  vase
+$  perm   ?(%w %r %$)
+$  arena  ?(%public %whitelist %team %me)
+$  perms  (map arena perm)
+$  ship   @p
+$  whitelist  (map ship perm)
::
+$  store  (mip =desk =key =value)
::
+$  action
  $%  [%let =desk]
      [%lie =desk]
      [%put =desk =key =value]
      [%del =desk =key]
      [%mode =arena =perm]
      [%whitelist =ship =perm]
      [%blacklist =ship]
      [%lockdown ~]
  ==
+$  update
  $%  [%desk (unit (map key value))]
      [%value (unit value)]
  ==
--
