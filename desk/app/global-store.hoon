  ::  global-store.hoon
::::
::    a simple key-value storage solution for ship-global values
::    with a straightforward permissions model
::
::    stores values as a (mip desk key vase)
::    returns values as (unit vase)
::
::    pokes:
::    %lie - delete a desk kvs
::    %put - put a value with a key onto a desk's kvs
::    %del - delete a key in a desk's kvs
::    %mode - change access perms for the specified group
::    %whitelist - put a ship on the whitelist
::    %whitewash - remove a ship from the whitelist
::    %lockdown - set only self to read-write perms (by default moon)
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
/+  verb, dbug, default-agent, *mip
::
=>
  |%
  +$  card  card:agent:gall
  +$  versioned-state  $%(state-zero)
  +$  state-zero
    $:  %zero
        =store:gs
        =perms:gs
        =whitelist:gs
    ==
  --
::
%+  verb  &
%-  agent:dbug
=|  state-zero
=*  state  -
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
      %zero  `this(state old)
    ==
  ::
  ++  on-poke
    |=  [=mark =vase]
    ~>  %bout.[0 '%global-store +on-poke']
    ~&  >>  store
    ^-  (quip card _this)
    ?+    mark  (on-poke:def mark vase)
        %global-store-action
      =+  !<(act=action:gs vase)
      ?-    -.act
          %lie
        ?>  (can-write desk.act src.bowl)
        =.  store  (~(del by store) desk.act)
        :_  this
        (give-updates:aux desk.act)
      ::
          %put
        ?>  (can-write desk.act src.bowl)
        =.  store  (~(put bi store) desk.act key.act value.act)
        :_  this
        (give-updates:aux desk.act key.act)
      ::
          %del
        ?>  (can-write desk.act src.bowl)
        =.  store  (~(del bi store) desk.act key.act)
        :_  this
        (give-updates:aux desk.act key.act)
      ::  XX probably wrong
      ::
          %mode
        ?>  =(our src):bowl
        :_  this(perms (~(put by perms) [desk.act arena.act] perm.act))
        ^-  (list card)
        ::  not removing access, or just myself
        ?:  ?|  !=(~ perm.act)
                =(%me arena.act)
            ==
          ~
        ::  ~ for %moon, %whitelist, %public
        %+  murn  ~(val by sup.bowl)
        |=  [=ship =path]
        ^-  (unit card)
        ?.  ?|  &(=(%moon arena.act) (moon:title our.bowl ship))
                &(=(%whitelist arena.act) (~(has by whitelist) [desk.act ship]))
                =(%public arena.act)
            ==
          ~
        `[%give %kick ~[path] `ship]
      ::
          %whitelist
        ?>  (can-write desk.act src.bowl)
        `this(whitelist (~(put by whitelist) [desk.act ship.act] perm.act))
      ::
          %whitewash
        ?>  (can-write desk.act src.bowl)
        ::  XX all paths
        :-  [%give %kick [[desk.act ~] ~] `ship.act]~
        this(whitelist (~(del by whitelist) desk.act ship.act))
      ::
          %lockdown
        ?>  (can-write desk.act src.bowl)
        =.  perms  (~(del by perms) desk.act)
        =.  whitelist  (~(del by whitelist) desk.act)
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
    ~>  %bout.[0 '%global-store +on-peek']
    ~&  >>  store
    ^-  (unit (unit cage))
    ?+    pole  (on-peek:def pole)
    ::  desk peek
    ::
        [%x desk=@ ~]
      ~&  >>>  'desk scry'
      =/  =desk  (slav %tas desk.pole)
      ?>  (can-read desk src.bowl)
      ``noun+!>((~(get by store) desk))
    ::  key peek
    ::
        [%x desk=@ key=@ ~]
      =/  =desk    (slav %tas desk.pole)
      ?>  (can-read desk src.bowl)
      =/  =key:gs  (slav %tas key.pole)
      ``noun+!>((~(get bi store) desk key))
    ==
  ::
  ++  on-agent  on-agent:def
  ++  on-arvo   on-arvo:def
  ++  on-watch
    |=  =(pole knot)
    ~>  %bout.[0 '%global-store +on-watch']
    ~&  >>  store
    ^-  (quip card _this)
    ::  on-watch, send them the value as a gift
    ?+    pole  (on-watch:def pole)
    ::  desk subscription (not common), send all values in (unitized) desk ksv
    ::
        [desk=@ ~]
      =/  =desk  (slav %tas desk.pole)
      ?>  (can-read desk src.bowl)
      :_  this  :_  ~
      [%give %fact ~ %noun !>((~(get by store) desk))]
    ::  key subscription, just send the (unitized) value
    ::
        [desk=@ key=@ ~]
      =/  =desk    (slav %tas desk.pole)
      ?>  (can-read desk src.bowl)
      =/  =key:gs  (slav %tas key.pole)
      :_  this  :_  ~
      [%give %fact ~ %noun !>((~(get bi store) desk key))]
    ==
  ::
  ++  on-leave  on-leave:def
  ++  on-fail   on-fail:def
  --
|_  =bowl:gall
++  can-read
  |=  [=desk =ship]
  ^-  ?
  =(?(%r %w) (what-perm desk ship))
::
++  can-write
  |=  [=desk =ship]
  ^-  ?
  =(%w (what-perm desk ship))
::  we check against the entire arena
::    our, whitelist, moon, public
::
++  what-perm
  |=  [=desk =ship]
  ^-  perm:gs
  ?:  =(our.bowl ship)  `%w
  ?:  (~(has by whitelist) [desk ship])
    (~(got by whitelist) [desk ship])
  ?:  ?&  (moon:title our.bowl ship)
          (~(has by perms) [desk %moon])
      ==
    (~(got by perms) [desk %moon])
  (~(gut by perms) [desk %public] ~)
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
        !>(`update:gs`value+(~(get bi store) desk key))
    ==
  --
--
