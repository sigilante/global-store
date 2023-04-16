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
  ++  on-init
    ^-  (quip card _this)
    ~>  %bout.[0 '%global-store +on-init']
    ~&  >>  store
    `this(perms default-perms)
  ::
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
        ?>  =(%w (what-perm:aux src.bowl))
        =.  store  (~(del by store) desk.act)
        =^  cards  state
          abet:(give-updates:aux desk.act)
        [cards this]
      ::
          %put
        ?>  =(%w (what-perm:aux src.bowl))
        =.  store  (~(put bi store) desk.act key.act value.act)
        =^  cards  state
          abet:(give-updates:aux desk.act key.act)
        [cards this]
      ::
          %del
        ?>  =(%w (what-perm:aux src.bowl))
        =.  store  (~(del bi store) desk.act key.act)
        =^  cards  state
          abet:(give-updates:aux desk.act key.act)
        [cards this]
      ::
          %mode
        ?>  =(our src):bowl
        :_  this(perms (~(put by perms) arena.act perm.act))
        ^-  (list card)
        ::  not removing access, or just myself
        ?:  ?|  !=(%$ perm.act)
                =(%me arena.act)
            ==
          ~
        ::  %$ for %moon, %whitelist, %public
        %+  murn  ~(val by sup.bowl)
        |=  [=ship =path]
        ^-  (unit card)
        ?.  ?|  &(=(%moon arena.act) (moon:title our.bowl ship))
                &(=(%whitelist arena.act) (~(has in whitelist) ship))
                =(%public arena.act)
            ==
          ~
        `[%give %kick ~[path] `ship]
      ::
          %whitelist
        ?>  =(%w (what-perm:aux src.bowl))
        `this(whitelist (~(put in whitelist) ship.act))
      ::
          %whitewash
        ?>  =(%w (what-perm:aux src.bowl))
        :-  [%give %kick ~ `ship.act]~
        this(whitelist (~(del in whitelist) ship.act))
      ::
          %lockdown
        ?>  =(%w (what-perm:aux src.bowl))
        :_  this(perms empty-perms, whitelist *whitelist:gs)
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
    ?>  =(?(%r %w) (what-perm:aux src.bowl))
    ?+    pole  (on-peek:def pole)
    ::  desk peek
    ::
        [%x desk=@ ~]
      ~&  >>>  'desk scry'
      =/  =desk  (slav %tas desk.pole)
      ``noun+!>((~(get by store) desk))
    ::  key peek
    ::
        [%x desk=@ key=@ ~]
      =/  =desk    (slav %tas desk.pole)
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
    ?>  =(?(%r %w) (what-perm:aux src.bowl))
    ?+    pole  (on-watch:def pole)
    ::  desk subscription (not common), send all values in (unitized) desk ksv
    ::
        [desk=@ ~]
      =/  =desk  (slav %tas desk.pole)
      :_  this  :_  ~
      [%give %fact ~ %noun !>((~(get by store) desk))]
    ::  key subscription, just send the (unitized) value
    ::
        [desk=@ key=@ ~]
      =/  =desk    (slav %tas desk.pole)
      =/  =key:gs  (slav %tas key.pole)
      :_  this  :_  ~
      [%give %fact ~ %noun !>((~(get bi store) desk key))]
    ==
  ::
  ++  on-leave  on-leave:def
  ++  on-fail   on-fail:def
  --
=|  cards=(list card)
|_  =bowl:gall
+*  aux   .
++  abet  [(flop cards) state]
++  emit  |=(=card aux(cards [card cards]))
++  emil  |=(caz=(list card) aux(cards (welp (flop caz) cards)))
::  we check against the entire arena
::
++  what-perm
  |=  =ship
  ^-  perm:gs
  ?:  =(our.bowl ship)
    (~(got by perms) %me)
  ?:  (moon:title our.bowl ship)
    (~(got by perms) %moon)
  ?:  (~(has in whitelist) ship)
    (~(got by perms) %whitelist)
  (~(got by perms) %public)
::
++  default-perms
  ^-  perms:gs
  %-  malt
  ^-  (list [arena:gs perm:gs])
  :~  :-  %public     *perm:gs
      :-  %whitelist  *perm:gs
      :-  %moon       %r
      :-  %me         %w
  ==
::
++  empty-perms
  ^-  perms:gs
  %-  malt
  ^-  (list [arena:gs perm:gs])
  :~  :-  %public     *perm:gs
      :-  %whitelist  *perm:gs
      :-  %moon       *perm:gs
      :-  %me         %w
  ==
::
++  give-updates
  |=  arg=$@(=desk [=desk =key:gs])
  |^  ^+  aux
      ?@  arg
        ::  desk update
        ::    /desk and /desk/*
        ::
        =.  aux  (emit (desk-update desk.arg))
        ::
        %-  emil
        %+  murn  ~(val by sup.bowl)
        |=  [* =(pole knot)]
        ?+    pole  ~
            [desk=@ key=@ ~]
          =/  d=desk    (slav %tas desk.pole)
          =/  k=key:gs  (slav %tas key.pole)
          ?.  =(d desk.arg)
            ~
          `(value-update desk.arg k)
        ==
      ::  value update
      ::    /desk and /desk/key
      ::
      =.  aux  (emit (desk-update desk.arg))
      (emit (value-update desk.arg key.arg))
  ::
  ++  value-update
    |=  [=desk =key:gs]
    ^-  card
    :*  %give  %fact
        [[desk key ~] ~]
        %global-store-update
        !>(`update:gs`value+(~(get bi store) desk key))
    ==
  ::
  ++  desk-update
    |=  =desk
    ^-  card
    :*  %give  %fact
        [[desk ~] ~]
        %global-store-update
        !>(`update:gs`desk+(~(get by store) desk))
    ==
  --
--
