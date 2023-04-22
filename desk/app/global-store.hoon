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
::    %del - delete a key in a desk's kvs (rm)
::    %lop - delete a key in a desk's kvs (rm -r)
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
/-  *global-store
/+  verb, dbug, default-agent
=>
  |%
  +$  card  card:agent:gall
  +$  state-0  [%0 =store =roll =objs =refs]
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
    =+  !<(act=action vase)
    ?-    -.act
        %put
      ?>  (can-write:aux src.bowl desk.act key.act)
      =/  hash   (shax (jam value.act))
      =/  old-hash  (~(get of store) [desk.act key.act])
      =.  store  (~(put of store) [desk.act key.act] hash)
      =.  refs   (~(put ju refs) hash [desk.act key.act])
      =?  objs  !(~(has by objs) hash)
        (~(put by objs) hash value.act)
      =?  refs  ?=(^ old-hash)
        (~(del ju refs) u.old-hash [desk.act key.act])
      =?  objs  &(?=(^ old-hash) =(~ (~(get ju refs) u.old-hash)))
        (~(del by objs) u.old-hash)
      :_  this
      (give-updates:aux desk.act key.act)
    ::
        %del
      ?>  (can-write:aux src.bowl desk.act key.act)
      =/  hash=(unit @uvI)  (~(get of store) [desk.act key.act])
      =.  store  (~(del of store) [desk.act key.act])
      =?  refs  ?=(^ hash)
        (~(del ju refs) u.hash [desk.act key.act])
      =?  objs  &(?=(^ hash) =(~ (~(get ju refs) u.hash)))
        (~(del by objs) u.hash)
      :_  this
      (give-updates:aux desk.act key.act)
    ::
        %lop
      ?>  (can-write:aux src.bowl desk.act key.act)
      ::  get all hashes at leaves
      ::  remove from refs
      ::  cleanup objects
      ::=.  store  (~(lop of store) [desk.act key.act])
      :_  this
      (give-updates:aux desk.act)
    ::
        %enroll
      ?>  (can-change-roll:aux src.bowl)
      =.  roll
        %-  ~(put of roll)
        ?-  -.arena.act
          %moon    :-  [desk.act %moon key.act]    perm.act
          %orbit   :-  [desk.act %orbit key.act]   perm.act
          %public  :-  [desk.act %public key.act]  perm.act
          %ship    :-  [desk.act (scot %p ship.arena.act) key.act]  perm.act
        ==
      :_  this
      ?~(perm.act (give-kicks:aux desk.act ~) ~)
    ::
        %unroll
      ?>  (can-change-roll:aux src.bowl)
      =.  roll
        %-  ~(del of roll)
        ?-  -.arena.act
          %moon    [desk.act %moon key.act]
          %orbit   [desk.act %orbit key.act]
          %public  [desk.act %public key.act]
          %ship    [desk.act (scot %p ship.arena.act) key.act]
        ==
      :_  this
      (give-kicks:aux desk.act ~)
    ::
        %lockdown
      ?>  (can-change-roll:aux src.bowl)
      =.  roll  (~(lop of roll) [desk.act key.act])
      :_  this
      (give-kicks:aux desk.act key.act)
    ==
  ::
  ++  on-peek
    |=  =(pole knot)
    ^-  (unit (unit cage))
    ?+    pole  (on-peek:def pole)
    ::  /desk
    ::
        [%x %desk desk=@ ~]
      ``noun+!>((~(get of store) /[desk.pole]))
    ::  /desk/key
    ::
        [%x %desk %key desk=@ key=*]
        ~&  >  %here
      =/  =desk    (slav %tas desk.pole)
      ``noun+!>((~(get of store) [desk key.pole]))
    ::  existance
    ::
    ::  /desk
    ::
        [%x %u %desk desk=@ ~]
      ``noun+!>((~(has of store) /[desk.pole]))
    ::  /desk/key
    ::
        [%x %u %desk %key desk=@ key=*]
      =/  =desk    (slav %tas desk.pole)
      ``noun+!>((~(has of store) [desk key.pole]))
    ::  /desk
    ::
        [%x %desk desk=@ ~]
      ``noun+!>((~(get of store) /[desk.pole]))
    ::  permissions
    ::
        [%x %roll ~]  ``noun+!>(roll)
    ::
        [%x %perm %ship %desk %key ship=@ desk=@ key=*]
      =/  =desk  (slav %tas desk.pole)
      =/  =ship  (slav %p ship.pole)
      ``noun+!>((what-perm:aux ship desk key.pole))
    ==
  ::
  ++  on-watch
    |=  =(pole knot)
    ^-  (quip card _this)
    ?+    pole  (on-watch:def pole)
    ::  key subscription: existance of a key
    ::
        [%u desk=@ key=*]
      =/  =desk  (slav %tas desk.pole)
      ?>  (can-read:aux src.bowl desk key.pole)
      `this
    ::  key subscription, just send the (unitized) value
    ::
        [desk=@ key=*]
      =/  =desk    (slav %tas desk.pole)
      ?>  (can-read:aux src.bowl desk key.pole)
      ~&  >  %passed-can-read-chck-on-watch
      ~&  >>  [desk key.pole]
      ::`this
      :_  this  :_  ~
      :*  %give  %fact  ~
          %global-store-update
          !>(`update`value+(key-to-val desk key.pole))
      ==
    ==
  ::
  ++  on-agent  on-agent:def
  ++  on-arvo   on-arvo:def
  ++  on-leave  on-leave:def
  ++  on-fail   on-fail:def
  --
|_  =bowl:gall
++  can-read   |=([=ship =desk =key] !=(~ (what-perm ship desk key)))
++  can-write  |=([=ship =desk =key] =(`%w (what-perm ship desk key)))
++  can-change-roll  |=(=ship |(=(our.bowl ship) (moon:title ship our.bowl)))
++  is-moon    |=(=ship =(%earl (clan:title ship)))
++  our-moon   |=(=ship (moon:title our.bowl ship))
++  our-sponsor   (get-sponsor our.bowl)
++  get-sponsor   |=(=ship (sein:title our.bowl now.bowl ship))
++  same-sponsor  |=([a=ship b=ship] =((get-sponsor a) (get-sponsor b)))
++  what-perm
  |=  [=ship =desk =key]
  ^-  perm
  ::  our
  ~&  >  %checking-our
  ?:  =(our.bowl ship)  `%w
  ~&  >  %checking-parent
  ::  our parent ship, if moon
  ?:  &((is-moon our.bowl) =(ship our-sponsor))
    `%w
  ::  explicitly set
  ~&  >  %checking-explicit
  =/  per=(unit perm)  +:(~(fit of roll) [desk (scot %p ship) key])
  ?^  per
    u.per
  ::  our moons
  ~&  >  %checking-moon
  =/  per=(unit perm)  +:(~(fit of roll) [desk %moon key])
  ?:  &((our-moon ship) ?=(^ per))
  ~&  >  [%got-moon-perm u.per]
    u.per
  ::::  fellow moons
  ~&  >  %checking-fellow-moons
  =/  per=(unit perm)  +:(~(fit of roll) [desk %orbit key])
  ?:  ?&  (is-moon our.bowl)
          (same-sponsor ship our.bowl)
          ?=(^ per)
      ==
    u.per
  ::::  public
  ~&  >  %checking-public
  =/  per=(unit perm)  +:(~(fit of roll) [desk %public key])
  ?^  per
    u.per
  ~
::
++  key-to-val
  |=  [=desk =key]
  ^-  (unit value)
  =/  val-key  (~(get of store) [desk key])
  ~&  >  val-key
  ?~  val-key
    ~
  =/  val  (~(get by objs) u.val-key)
  ~&  >  val
  val
::
++  give-kicks
  |=  [=desk =key]
  ~&  >  %giving-kicks
  ^-  (list card)
  %+  murn  ~(val by sup.bowl)
  |=  [=ship =(pole knot)]
  ^-  (unit card)
  ?.  &(?=([desk=@ *] pole) =(desk desk.pole))
    ~
  ?:  (can-read ship desk key)
    ~
  `[%give %kick [pole ~] `ship]
::
++  give-updates
  |=  arg=$@(=desk [=desk =path])
  |^  ^-  (list card)
      ?^  arg
        ::  value update
        ::    /desk and /desk/path
        ::
            (value-update desk.arg path.arg)^~
      ::  desk update
      ::    /desk and /desk/*
      ::
      %+  turn  ~(tap in (desk-keys desk.arg))
      |=  =key
      (value-update desk.arg key)
  ::
  ++  desk-keys
    |=  =desk
    ^-  (set path)
    %-  sy
    %+  murn  ~(val by sup.bowl)
    |=  [* =(pole knot)]
    ?.  &(?=([desk=@ path=*] pole) =(desk.pole desk))
      ~
    `path.pole
  ::  existance of a path
  ::
  ++  key-update
    |=  [=desk =key]
    ^-  card
    :*  %give  %fact  [[%u desk key] ~]
        %global-store-update
        !>(`update`key+[desk [key (~(has of store) [desk key])]])
    ==
  ::
  ++  value-update
    |=  [=desk =key]
    ^-  card
    :*  %give  %fact  [[desk key] ~]
        %global-store-update
        !>(`update`value+(key-to-val desk key))
    ==
  --
--
