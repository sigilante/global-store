  ::  /sur/global-store.hoon
::::  ~lagrev-nocfep
::    Version ~2023.7.28
::
::    a simple key-value storage solution for ship-global values
::    with a straightforward permissions model
::
::    stores values as a (mip desk key vase)
::    returns values as (unit vase)
::
::    pokes:
::    %let - create a desk kvs
::    %lie - delete a desk kvs
::    %put - put a value with a key onto a desk's kvs
::    %del - delete a key in a desk's kvs
::    %mode - change access perms for the specified group
::    %enroll - put a ship on the roll
::    %unroll - remove a ship from the roll
::    %lockdown - set only self to read-write perms for a desk (by default moon)
::
::    your basic use pattern will be to put important global
::    values into your desk's store with `%put`
::    or to read out an important value by peeking or subscribing and
::    receiving a gift in return
::
::    you'll either peek to /x/[desk]/[key] for a value or
::    subscribe to /[desk]/[key] for a value
::
::    the advantage of subscribing is that you receive changes to the value
::
/-  gs=global-store
/+  dbug, default-agent, mip, verb
::
|%
+$  versioned-state
  $%  state-0
  ==
+$  state-0
  $:  [%0 =store:gs =roll:gs]
  ==
+$  card  card:agent:gall
--
::
=|  state-0
=*  state  -
::
%+  verb  &
%-  agent:dbug
^-  agent:gall
=<
|_  =bowl:gall
+*  this  .
    def   ~(. (default-agent this %|) bowl)
    aux   ~(. +> bowl)
++  on-init  on-init:def
++  on-save  !>(state)
++  on-load
  |=  =vase
  ^-  (quip card _this)
  =+  !<(old=versioned-state vase)
  ?-  -.old
    %0  `this(state old)
  ==
::
++  on-poke
  |=  [=mark =vase]
  ^-  (quip card _this)
  ?+    mark  (on-poke:def mark vase)
      %global-store-action
    =+  !<(act=action:gs vase)
    ?-    -.act
    ::  when we produce a new desk key-value store, we "bunt" it w/ its name
    ::  strictly speaking, put could duplicate this functionality but
    ::  we want put to fail if there's a typo in the desk name
    ::
        %let
      ?>  (can-write:aux desk.act src.bowl)
      =.  store  (~(put bi:mip store) desk.act %name !>(desk.act))
      :_  this
      (give-updates:aux desk.act)
    ::
        %lie
      ?>  (can-write:aux desk.act src.bowl)
      =.  store  (~(del by store) desk.act)
      :_  this
      (give-updates:aux desk.act)
    ::
        %put
      ?>  (can-write:aux desk.act src.bowl)
      =.  store  (~(put bi:mip store) desk.act key.act value.act)
      :_  this
      (give-updates:aux desk.act key.act)
    ::
        %del
      ?>  (can-write:aux desk.act src.bowl)
      =.  store  (~(del bi:mip store) desk.act key.act)
      :_  this
      (give-updates:aux desk.act key.act)
    ::  XX probably wrong
    ::
        %mode
      ?>  =(our src):bowl
      :_  this(roll (~(put by roll) [desk.act arena.act] perm.act))
      ^-  (list card)
      ::  not removing access
      ?.  =(~ perm.act)
        ~
      ::  ~ for %moon, %roll, %public
      %+  murn  ~(val by sup.bowl)
      |=  [=ship =path]
      ^-  (unit card)
      ?.  ?|  &(=(%moon arena.act) (moon:title our.bowl ship))
              &(=(%enroll arena.act) (~(has by roll) [desk.act ship]))
              =(%public arena.act)
          ==
        ~
      `[%give %kick ~[path] `ship]
    ::  ship or arena
    ::
        %enroll
      ?>  (can-write:aux desk.act src.bowl)
      ?:  ?=(arena:gs wut.act)
          ~&  >>  %arena
        `this(roll (~(put by roll) [desk.act wut.act] perm.act))
      ?>  ?=(ship wut.act)
      ~&  >>  %ship
      `this(roll (~(put by roll) [desk.act wut.act] perm.act))
    ::  ship or arena
    ::    XX all paths
    ::
        %unroll
      ?>  (can-write:aux desk.act src.bowl)
      ?:  ?=(arena:gs wut.act)
          ~&  >>  %arena
        `this(roll (~(del by roll) [desk.act wut.act]))
      ?>  ?=(ship wut.act)
      ~&  >>  %ship
      :-  [%give %kick [[desk.act ~] ~] `wut.act]~
      this(roll (~(del by roll) [desk.act wut.act]))
    ::
        %lockdown
      ?>  (can-write:aux desk.act src.bowl)
      =.  roll  (~(del by roll) desk.act)
      :_  this
      ^-  (list card)
      %+  murn  ~(val by sup.bowl)
      |=  [=ship =path]
      ^-  (unit card)
      ?:  =(ship our.bowl)
        ~
      `[%give %kick ~[path] `ship]
    ==  ::  head tag
  ==    ::  poke type
::
++  on-peek
  |=  =(pole knot)
  ^-  (unit (unit cage))
  ?+    pole  (on-peek:def pole)
  ::  desk peek
  ::
      [%x %desk desk=@ ~]
    =/  =desk  (slav %tas desk.pole)
    ?>  (can-read:aux desk src.bowl)
    ``noun+!>((~(get by store) desk))
  ::  key peek
  ::
      [%x %key desk=@ key=@ ~]
    =/  =desk    (slav %tas desk.pole)
    ?>  (can-read:aux desk src.bowl)
    =/  =key:gs  (slav %tas key.pole)
    ``noun+!>((~(get bi:mip store) desk key))
  ==
::
++  on-agent  on-agent:def
++  on-arvo   on-arvo:def
::  +on-watch, send them the value as a gift
::
++  on-watch
  |=  =(pole knot)
  ^-  (quip card _this)
  ?+    pole  (on-watch:def pole)
  ::  desk subscription (not common), send all values in (unitized) desk ksv
  ::
      [desk=@ ~]
    =/  =desk  (slav %tas desk.pole)
    ?>  (can-read:aux desk src.bowl)
    :_  this  :_  ~
    [%give %fact ~ %noun !>((~(get by store) desk))]
  ::  key subscription, just send the (unitized) value
  ::
      [desk=@ key=@ ~]
    =/  =desk    (slav %tas desk.pole)
    ?>  (can-read:aux desk src.bowl)
    =/  =key:gs  (slav %tas key.pole)
    :_  this  :_  ~
    [%give %fact ~ %noun !>((~(get bi:mip store) desk key))]
  ==
::
++  on-leave  on-leave:def
++  on-fail   on-fail:def
--
::
::  helper core
::
|_  =bowl:gall
++  can-read   |=([=desk =ship] !=(~ (what-perm desk ship)))
++  can-write  |=([=desk =ship] =(`%w (what-perm desk ship)))
::  we check against the entire arena
::    our, roll, moon, public
::
++  what-perm
  |=  [=desk =ship]
  ^-  perm:gs
  ?:  =(our.bowl ship)  `%w
  ?:  (~(has by roll) [desk ship])
    (~(got by roll) [desk ship])
  ?:  ?&  (moon:title our.bowl ship)
          (~(has by roll) [desk %moon])
      ==
    (~(got by roll) [desk %moon])
  (~(gut by roll) [desk %public] ~)
::
++  give-updates
  |=  arg=$@(=desk [=desk =key:gs])
  |^  ^-  (list card)
      ?^  arg
        ::  value update
        ::    /desk and /desk/key
        ::
        :~  (desk-update desk.arg)
            (value-update desk.arg key.arg)
        ==
      ::  desk update
      ::    /desk and /desk/*
      ::
      ::  keys for this desk
      ::
      =/  keys=(set key:gs)
        %-  sy
        %+  murn  ~(val by sup.bowl)
        |=  [* =(pole knot)]
        ?.  ?&  ?=([desk=@ key=@ ~] pole)
                =(desk.pole desk.arg)
            ==
          ~
        `key.pole
      ::  desk update card
      ::
      :-  (desk-update desk.arg)
      ::  value update cards
      ::
      %+  turn  ~(tap in keys)
      |=  =key:gs
      (value-update desk.arg key)
  ::
  ++  desk-update
    |=  =desk
    ^-  card
    :*  %give  %fact
        [[desk ~] ~]
        %global-store-update
        !>(`update:gs`desk+(~(get by store) desk))
    ==
  ::
  ++  value-update
    |=  [=desk =key:gs]
    ^-  card
    :*  %give  %fact
        [[desk key ~] ~]
        %global-store-update
        !>(`update:gs`value+(~(get bi:mip store) desk key))
    ==
  --
--
