  ::  %global-store
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
=>
  |%
  +$  card  card:agent:gall
  +$  state-0  [%0 =store:gs =roll:gs]
  --
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
  ++  on-load  |=(=vase `this(state !<(state-0 vase)))
  ++  on-poke
    |=  [=mark =vase]
    ^-  (quip card _this)
    ?.  =(%global-store-action mark)  (on-poke:def mark vase)
    =+  !<(act=action:gs vase)
    ?-    -.act
        %put
      ?>  (can-write:aux desk.act src.bowl)
      =.  store  (~(put bi store) [desk key value]:act)
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
      ?>  (can-change-roll:aux src.bowl)
      =.  roll  (~(put bi roll) [desk whom perm]:act)
      :_  this
      ?~(perm.act (give-kicks:aux desk.act) ~)
    ::
        %unroll
      ?>  (can-change-roll:aux src.bowl)
      =.  roll  (~(del bi roll) desk.act whom.act)
      :_  this
      (give-kicks:aux desk.act)
    ::
        %lockdown
      ?>  (can-change-roll:aux src.bowl)
      =.  roll  (~(del by roll) desk.act)
      :_  this
      (give-kicks:aux desk.act)
    ==
  ::
  ++  on-peek
    |=  =(pole knot)
    ^-  (unit (unit cage))
    ?+    pole  (on-peek:def pole)
    ::  /desk
    ::
        [%x %desk desk=@ ~]
      ``noun+!>((~(get by store) (slav %tas desk.pole)))
    ::  /desk/key
    ::
        [%x %desk %key desk=@ key=*]
      =/  =desk    (slav %tas desk.pole)
      ``noun+!>((~(get bi store) desk key.pole))
    ::  existance
    ::
    ::  /desk
    ::
        [%x %u %desk desk=@ ~]
      ``noun+!>((~(has by store) (slav %tas desk.pole)))
    ::
    ::  /desk/key
    ::
        [%x %u %desk %key desk=@ key=*]
      =/  =desk    (slav %tas desk.pole)
      ``noun+!>((~(has bi store) desk key.pole))
    ::  /desk
    ::
        [%x %desk desk=@ ~]
      ``noun+!>((~(get by store) (slav %tas desk.pole)))
    ::  permissions
    ::
        [%x %roll ~]  ``noun+!>(roll)
    ::
        [%x %perm %desk %ship desk=@ ship=@ ~]
      =/  =desk  (slav %tas desk.pole)
      =/  =ship  (slav %p ship.pole)
      ``noun+!>((what-perm:aux desk ship))
    ::
        [%x %perm %desk %arena desk=@ arena=@ ~]
      =/  =desk  (slav %tas desk.pole)
      =/  arena  (slav %tas arena.pole)
      ``noun+!>((~(gut bi roll) desk arena ~))
    ==
  ::
  ++  on-watch
    |=  =(pole knot)
    ^-  (quip card _this)
    ?+    pole  (on-watch:def pole)
    ::  desk subscription: existance of a desk
    ::
        [%u desk=@ ~]
      =/  =desk  (slav %tas desk.pole)
      ?>  (can-read:aux desk src.bowl)
      :_  this  :_  ~
      :*  %give  %fact  ~
          %global-store-update
          !>(desk+[desk (~(has by store) desk)])
      ==
    ::  key subscription: existance of a key
    ::
        [%u desk=@ key=*]
      =/  =desk  (slav %tas desk.pole)
      ?>  (can-read:aux desk src.bowl)
      :_  this  :_  ~
      :*  %give  %fact  ~
          %global-store-update
          !>(key+[desk [key.pole (~(has bi store) desk key.pole)]])
      ==
    ::  key subscription, just send the (unitized) value
    ::
        [%x desk=@ key=*]
      =/  =desk    (slav %tas desk.pole)
      ?>  (can-read:aux desk src.bowl)
      :_  this  :_  ~
      :*  %give  %fact  ~
          %global-store-update
          !>(value+(~(get bi store) desk key.pole))
      ==
    ==
  ::
  ++  on-agent  on-agent:def
  ++  on-arvo   on-arvo:def
  ++  on-leave  on-leave:def
  ++  on-fail   on-fail:def
  --
|_  =bowl:gall
++  can-read   |=([=desk =ship] !=(~ (what-perm desk ship)))
++  can-write  |=([=desk =ship] =(`%w (what-perm desk ship)))
++  can-change-roll  |=(=ship |(=(our.bowl ship) (moon:title ship our.bowl)))
++  is-moon   |=(=ship =(%earl (clan:title ship)))
++  our-moon  |=(=ship (moon:title our.bowl ship))
++  our-sponsor   (get-sponsor our.bowl)
++  get-sponsor   |=(=ship (sein:title our.bowl now.bowl ship))
++  same-sponsor  |=([a=ship b=ship] =((get-sponsor a) (get-sponsor b)))
++  what-perm
  |=  [=desk =ship]
  ^-  perm:gs
  ::  our
  ?:  =(our.bowl ship)  `%w
  ::  our parent ship, if moon
  ?:  &((is-moon our.bowl) =(ship our-sponsor))
    `%w
  ::  explicitly set
  ?:  (~(has bi roll) desk ship)
    (~(got bi roll) desk ship)
  ::  our moons
  ?:  &((our-moon ship) (~(has bi roll) desk %moon))
    (~(got bi roll) desk %moon)
  ::  fellow moons
  ?:  ?&  (is-moon our.bowl)
          (same-sponsor ship our.bowl)
          (~(has bi roll) desk %orbit)
      ==
    (~(got bi roll) desk %orbit)
  ::  public
  (~(gut bi roll) desk %public ~)
::
++  give-kicks
  |=  =desk
  ^-  (list card)
  %+  murn  ~(val by sup.bowl)
  |=  [=ship =(pole knot)]
  ^-  (unit card)
  ?.  &(?=([desk=@ *] pole) =(desk desk.pole))
    ~
  ?:  (can-read desk ship)
    ~
  `[%give %kick [pole ~] `ship]
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
      :-  (desk-update desk.arg)
      %+  turn  ~(tap in (desk-keys desk.arg))
      |=  =key:gs
      (value-update desk.arg key)
  ::
  ++  desk-keys
    |=  =desk
    ^-  (set key:gs)
    %-  sy
    %+  murn  ~(val by sup.bowl)
    |=  [* =(pole knot)]
    ?.  &(?=([desk=@ key=*] pole) =(desk.pole desk))
      ~
    `key.pole
  ::  existance of a key
  ::
  ++  key-update
    |=  [=desk =key:gs]
    ^-  card
    :*  %give  %fact  [[%u desk key] ~]
        %global-store-update
        !>(key+[key (~(has bi store) desk key)])
    ==
  ::  existance of a desk
  ::
  ++  desk-update
    |=  =desk
    ^-  card
    :*  %give  %fact  [[%u desk ~] ~]
        %global-store-update
        !>(desk+[desk (~(has by store) desk)])
    ==
  ::
  ++  value-update
    |=  [=desk =key:gs]
    ^-  card
    :*  %give  %fact  [[%x desk key] ~]
        %global-store-update
        !>(value+(~(get bi store) desk key))
    ==
  --
--
