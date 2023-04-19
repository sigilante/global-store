  ::  global-store
::::
::    a simple key-value storage solution for ship-global values
::    with a straightforward permissions model
::
::    stores values as a (mip keep key vase)
::    returns values as (unit vase)
::
::    pokes:
::    %put - put a value with a key onto a keep's kvs
::    %del - delete a key in a keep's kvs
::    %lie - delete a keep kvs
::    %enroll - put a ?(ship arena) on the roll
::    %unroll - remove a ?(ship arena) from the roll
::    %lockdown - set only self to read-write perms for a keep
::
::    your basic use pattern will be to put important global
::    values into your keep's store with `%put`
::    or to read out an important value by peeking or subscribing and
::    receiving a gift in return
::
::    for a value you'll peek to
::    /x/keep/[keep] or /x/keep/key/[keep]/[key]
::    or subscribe to /[keep] or /[keep]/[key]
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
      ?>  (can-write:aux keep.act src.bowl)
      =.  store  (~(put bi store) [keep key value]:act)
      :_  this
      (give-updates:aux keep.act key.act)
    ::
        %del
      ?>  (can-write:aux keep.act src.bowl)
      =.  store  (~(del bi store) keep.act key.act)
      :_  this
      (give-updates:aux keep.act key.act)
    ::
        %lie
      ?>  (can-write:aux keep.act src.bowl)
      =.  store  (~(del by store) keep.act)
      :_  this
      (give-updates:aux keep.act)
    ::
        %enroll
      ?>  (can-change-roll:aux src.bowl)
      =.  roll  (~(put bi roll) [keep whom perm]:act)
      :_  this
      ?~(perm.act (give-kicks:aux keep.act) ~)
    ::
        %unroll
      ?>  (can-change-roll:aux src.bowl)
      =.  roll  (~(del bi roll) keep.act whom.act)
      :_  this
      (give-kicks:aux keep.act)
    ::
        %lockdown
      ?>  (can-change-roll:aux src.bowl)
      =.  roll  (~(del by roll) keep.act)
      :_  this
      (give-kicks:aux keep.act)
    ==
  ::
  ++  on-peek
    |=  =(pole knot)
    ^-  (unit (unit cage))
    ?+    pole  (on-peek:def pole)
    ::  /keep
    ::
        [%x %keep keep=@ ~]
      ``noun+!>((~(get by store) (slav %tas keep.pole)))
    ::  /keep/key
    ::
        [%x %keep %key keep=@ key=@ ~]
      =/  =keep:gs  (slav %tas keep.pole)
      =/  =key:gs   (slav %tas key.pole)
      ``noun+!>((~(get bi store) keep key))
    ::  permissions
    ::
        [%x %roll ~]  ``noun+!>(roll)
    ::
        [%x %perm %keep %ship keep=@ ship=@ ~]
      =/  =keep:gs  (slav %tas keep.pole)
      =/  =ship     (slav %p ship.pole)
      ``noun+!>((what-perm:aux keep ship))
    ::
        [%x %perm %keep %arena keep=@ arena=@ ~]
      =/  =keep:gs  (slav %tas keep.pole)
      =/  arena     (slav %tas arena.pole)
      ``noun+!>((~(gut bi roll) keep arena ~))
    ==
  ::
  ++  on-watch
    |=  =(pole knot)
    ^-  (quip card _this)
    ?+    pole  (on-watch:def pole)
    ::  keep subscription (not common), send all values in (unitized) keep kvs
    ::
        [keep=@ ~]
      =/  =keep:gs  (slav %tas keep.pole)
      ?>  (can-read:aux keep src.bowl)
      :_  this  :_  ~
      :*  %give  %fact  ~
          %global-store-update
          !>(keep+(~(get by store) keep))
      ==
    ::  key subscription, just send the (unitized) value
    ::
        [keep=@ key=@ ~]
      =/  =keep:gs  (slav %tas keep.pole)
      ?>  (can-read:aux keep src.bowl)
      =/  =key:gs   (slav %tas key.pole)
      :_  this  :_  ~
      :*  %give  %fact  ~
          %global-store-update
          !>(value+(~(get bi store) keep key))
      ==
    ==
  ::
  ++  on-agent  on-agent:def
  ++  on-arvo   on-arvo:def
  ++  on-leave  on-leave:def
  ++  on-fail   on-fail:def
  --
|_  =bowl:gall
++  can-read   |=([=keep:gs =ship] !=(~ (what-perm keep ship)))
++  can-write  |=([=keep:gs =ship] =(`%w (what-perm keep ship)))
++  can-change-roll  |=(=ship |(=(our.bowl ship) (moon:title ship our.bowl)))
++  is-moon   |=(=ship =(%earl (clan:title ship)))
++  our-moon  |=(=ship (moon:title our.bowl ship))
++  our-sponsor   (get-sponsor our.bowl)
++  get-sponsor   |=(=ship (sein:title our.bowl now.bowl ship))
++  same-sponsor  |=([a=ship b=ship] =((get-sponsor a) (get-sponsor b)))
++  what-perm
  |=  [=keep:gs =ship]
  ^-  perm:gs
  ::  our
  ?:  =(our.bowl ship)  `%w
  ::  our parent ship, if moon
  ?:  &((is-moon our.bowl) =(ship our-sponsor))
    `%w
  ::  explicitly set
  ?:  (~(has bi roll) keep ship)
    (~(got bi roll) keep ship)
  ::  our moons
  ?:  &((our-moon ship) (~(has bi roll) keep %moon))
    (~(got bi roll) keep %moon)
  ::  fellow moons
  ?:  ?&  (is-moon our.bowl)
          (same-sponsor ship our.bowl)
          (~(has bi roll) keep %orbit)
      ==
    (~(got bi roll) keep %orbit)
  ::  public
  (~(gut bi roll) keep %public ~)
::
++  give-kicks
  |=  =keep:gs
  ^-  (list card)
  %+  murn  ~(val by sup.bowl)
  |=  [=ship =(pole knot)]
  ^-  (unit card)
  ?.  &(?=([keep=@ *] pole) =(keep keep.pole))
    ~
  ?:  (can-read keep ship)
    ~
  `[%give %kick [pole ~] `ship]
::
++  give-updates
  |=  arg=$@(=keep:gs [=keep:gs =key:gs])
  |^  ^-  (list card)
      ?^  arg
        ::  value update
        ::    /keep and /keep/key
        ::
        :~  (keep-update keep.arg)
            (value-update keep.arg key.arg)
        ==
      ::  keep update
      ::    /keep and /keep/*
      ::
      :-  (keep-update keep.arg)
      %+  turn  ~(tap in (keep-keys keep.arg))
      |=  =key:gs
      (value-update keep.arg key)
  ::
  ++  keep-keys
    |=  =keep:gs
    ^-  (set key:gs)
    %-  sy
    %+  murn  ~(val by sup.bowl)
    |=  [* =(pole knot)]
    ?.  &(?=([keep=@ key=@ ~] pole) =(keep.pole keep))
      ~
    `key.pole
  ::
  ++  keep-update
    |=  =keep:gs
    ^-  card
    :*  %give  %fact  [[keep ~] ~]
        %global-store-update
        !>(keep+(~(get by store) keep))
    ==
  ::
  ++  value-update
    |=  [=keep:gs =key:gs]
    ^-  card
    :*  %give  %fact  [[keep key ~] ~]
        %global-store-update
        !>(value+(~(get bi store) keep key))
    ==
  --
--
