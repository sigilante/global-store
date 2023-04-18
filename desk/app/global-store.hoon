  ::  global-store.hoon
::::
::    a simple key-value storage solution for ship-global values
::    with a straightforward permissions model
::
::    stores values as a (mip desk key vase)
::    returns values as (unit vase)
::
::    pokes:
::    %put - put a value with a key onto a desk's kvs
::    %del - delete a key in a desk's kvs
::    %lie - delete a desk kvs
::    %enroll - put a ?(ship arena) on the roll
::    %unroll - remove a ?(ship arena) from the roll
::    %lockdown - set only self to read-write perms for a desk
::
::    your basic use pattern will be to put important global
::    values into your desk's store with `%put`
::    or to read out an important value by peeking or subscribing and
::    receiving a gift in return
::
::    for a value you'll peek to
::    /x/desk/[desk] or /x/desk/key/[desk]/[key]
::    or subscribe to /[desk] or /[desk]/[key]
::
::    the advantage of subscribing is that you receive changes to the value
::
/-  gs=global-store
/+  verb, dbug, default-agent, *mip
::
=>
  |%
  +$  card  card:agent:gall
  +$  versioned-state  $%(state-0)
  +$  state-0
    $:  %0
        =store:gs
        =roll:gs
    ==
  --
::
=|  state-0
=*  state  -
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
          %put
        ?>  (can-write:aux desk.act src.bowl)
        =.  store  (~(put bi store) desk.act key.act value.act)
        :_  this
        (give-updates:aux desk.act key.act)
      ::
          %del
        ?>  (can-write:aux desk.act src.bowl)
        =.  store  (~(del bi store) desk.act key.act)
        :_  this
        (give-updates:aux desk.act key.act)
      ::
          %lie
        ?>  (can-write:aux desk.act src.bowl)
        =.  store  (~(del by store) desk.act)
        :_  this
        (give-updates:aux desk.act)
      ::
          %enroll
        ?>  =(our src):bowl
        =.  roll  (~(put by roll) [desk.act wut.act] perm.act)
        :_  this
        ?~(perm.act (give-kicks:aux desk.act) ~)
      ::
          %unroll
        ?>  =(our src):bowl
        =.  roll  (~(del by roll) [desk.act wut.act])
        :_  this
        (give-kicks:aux desk.act)
      ::
          %lockdown
        ?>  =(our src):bowl
        =.  roll  (~(del by roll) desk.act)
        :_  this
        (give-kicks:aux desk.act)
      ==
    ==
  ::
  ++  on-peek
    |=  =(pole knot)
    ^-  (unit (unit cage))
    ?+    pole  (on-peek:def pole)
    ::  /desk peek
    ::
        [%x %desk desk=@ ~]
      =/  =desk  (slav %tas desk.pole)
      ``noun+!>((~(get by store) desk))
    ::  /desk/key peek
    ::
        [%x %desk %key desk=@ key=@ ~]
      =/  =desk    (slav %tas desk.pole)
      =/  =key:gs  (slav %tas key.pole)
      ``noun+!>((~(get bi store) desk key))
    ::  permissions
    ::
        [%x %roll ~]
      ``noun+!>(roll)
    ::
        [%x %perm %desk %ship desk=@ ship=@ ~]
      =/  =desk  (slav %tas desk.pole)
      =/  =ship  (slav %p ship.pole)
      ``noun+!>((what-perm desk ship))
    ::
        [%x %perm %desk %arena desk=@ arena=@ ~]
      =/  =desk  (slav %tas desk.pole)
      =/  arena  (slav %tas arena.pole)
      ``noun+!>((~(get by roll) desk arena))
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
      [%give %fact ~ %noun !>((~(get bi store) desk key))]
    ==
  ::
  ++  on-leave  on-leave:def
  ++  on-fail   on-fail:def
  --
|_  =bowl:gall
++  can-read   |=([=desk =ship] !=(~ (what-perm desk ship)))
++  can-write  |=([=desk =ship] =(`%w (what-perm desk ship)))
::  check perms for our, roll, moon, then public
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
++  give-kicks
  |=  =desk
  ^-  (list card)
  %+  murn  ~(val by sup.bowl)
  |=  [=ship =(pole knot)]
  ^-  (unit card)
  ?.  ?&  ?=([desk=@ *] pole)
          =(desk.pole desk)
      ==
    ~
  ?:  (can-read desk ship)
    ~
  `[%give %kick [pole ~] `ship]

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
        !>(`update:gs`value+(~(get bi store) desk key))
    ==
  --
--
