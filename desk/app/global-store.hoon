::    %global-store
::::
  ::  a simple key-value storage solution for ship-global values
::    with a straightforward permissions model
::
::    permissions are stored as an (axal perm)
::    keys are stored as an (axal @uvI)
::    objects are stored as a (map @uvI vase)
::    references are stored as a (jug @uvI path)
::    returns values as (unit cage)
::
::    pokes:
::    %put - put a value with a key onto a desk's kvs
::    %del - delete a key in a desk's kvs (rm)
::    %lop - delete keys in a desk's kvs (rm -r)
::    %enroll - put an arena on the roll
::    %unroll - remove an arena from the roll
::    %lockdown - set only self to read-write perms for a desk
::    %watch - watch a %desk /key
::    %leave - leave a %desk /key
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
/-  *global-store, update
/+  verb, dbug, default-agent, sss
=>
  |%
  +$  card  $+(card card:agent:gall)
  +$  state-0
    $:  %0
        =store  =roll  =objs  =refs
        pubs=_(mk-pubs:sss update ,[* *])
    ==
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
      dup   =/  du  (du:sss update ,[* *])
            (du pubs bowl -:!>(*result:du))
  ++  on-init  on-init:def
  ++  on-save  !>(state)
  ++  on-load  |=(=vase `this(state !<(state-0 vase)))
  ++  on-poke
    |=  [=mark =vase]
    ^-  (quip card _this)
    ~&  >>  "pubs was: {<read:dup>}"
    ?+    mark  (on-poke:def mark vase)
        %global-store-action
      =+  !<(act=action vase)
      ?-    -.act
          %put
        ?>  (can-write:aux src.bowl desk.act key.act)
        =/  hash=@uvI  (shax (jam value.act))
        =/  old-hash   (~(get of store) [desk.act key.act])
        ?:  &(?=(^ old-hash) =(hash u.old-hash))
          [~ this]
        =.  store  (~(put of store) [desk.act key.act] hash)
        =.  refs   (~(put ju refs) hash [desk.act key.act])
        =?  objs  !(~(has by objs) hash)
          (~(put by objs) hash value.act)
        =?  refs  &(?=(^ old-hash) !=(u.old-hash hash))
          (~(del ju refs) u.old-hash [desk.act key.act])
        =?  objs  &(?=(^ old-hash) =(~ (~(get ju refs) u.old-hash)))
          (~(del by objs) u.old-hash)
        =.  pubs  (rule:dup [[desk.act key.act]~ 0 0])  
        =^  cards  pubs
          (give:dup [desk.act key.act]~ [%value (key-to-val desk.act key.act)])
          ~&  >  "pubs is: {<read:dup>}"
        [cards this]
      ::
          %del
        ?>  (can-write:aux src.bowl desk.act key.act)
        =/  hash=(unit @uvI)  (~(get of store) [desk.act key.act])
        =.  store  (~(del of store) [desk.act key.act])
        =?  refs  ?=(^ hash)
          (~(del ju refs) u.hash [desk.act key.act])
        =?  objs  &(?=(^ hash) =(~ (~(get ju refs) u.hash)))
          (~(del by objs) u.hash)
        =^  cards  pubs
          (give:dup [desk.act key.act]~ [%value (key-to-val desk.act key.act)])
          ~&  >  "pubs is: {<read:dup>}"
        [cards this]
      ::
          %lop
        ?>  (can-write:aux src.bowl desk.act key.act)
        ::  get all relevant keys and hashes
        =/  old=(list (pair path @uvI))
          %~  tap  of
          (~(dip of store) [desk.act key.act])
        ::  update store
        =.  store  (~(lop of store) [desk.act key.act])
        ::  remove from refs, cleanup objs
        =.  state
          |-
          ?~  old
            state
          =/  =path  [desk.act (weld key.act p.i.old)]
          =.  refs   (~(del ju refs) q.i.old path)
          =?  objs  =(~ (~(get ju refs) q.i.old))
            (~(del by objs) q.i.old)
          $(old t.old)
        ::  XX  update all paths
        [~ this]
      ::
          %enroll
        ?>  (can-change-roll:aux src.bowl)
        =.  roll
          %-  ~(put of roll)
          ?-  -.arena.act
            %moon    :-  [desk.act %moon key.act]    perm.act
            %orbit   :-  [desk.act %orbit key.act]   perm.act
            %kids    :-  [desk.act %kids key.act]    perm.act
            %public  :-  [desk.act %public key.act]  perm.act
            %ship    :-  [desk.act (scot %p ship.arena.act) key.act]  perm.act
          ==
        =?  pubs  ?=(~ perm.act)
          (give-kicks:aux desk.act ~)
        [~ this]
      ::
          %unroll
        ?>  (can-change-roll:aux src.bowl)
        =.  roll
          %-  ~(del of roll)
          ?-  -.arena.act
            %moon    [desk.act %moon key.act]
            %orbit   [desk.act %orbit key.act]
            %kids    [desk.act %kids key.act]
            %public  [desk.act %public key.act]
            %ship    [desk.act (scot %p ship.arena.act) key.act]
          ==
        =.  pubs  (give-kicks:aux desk.act ~)
        [~ this]
      ::
          %lockdown
        ?>  (can-change-roll:aux src.bowl)
        =.  roll  (~(lop of roll) /[desk.act])
        ::  XX  all paths
        =.  pubs  (kill:dup [desk.act *]~)
        `this
      ::
          %watch
        ?>  (can-read src.bowl desk.act key.act)
        =.  pubs  (allow:dup [src.bowl ~] [desk.act key.act]~)
        =^  cards  pubs
          (give:dup [desk.act key.act]~ [%value (key-to-val desk.act key.act)])
          ~&  >  "pubs is: {<read:dup>}"
        [cards this]
      ::
          %leave
        =.  pubs  (block:dup [src.bowl ~] [desk.act key.act]~)
        ~&  >  "pubs is: {<read:dup>}"
        [~ this]
      ==
    ::  sss - required w/o crashing
    ::    %sss-to-pub   Information to be handled by a du-core (i.e. a publication).
    ::
        %sss-to-pub
      ~&  >  %sss-to-pub
      =+  msg=!<($%(into:dup) (fled:sss vase))
      =^  cards  pubs  (apply:dup msg)
      [cards this]
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
      =/  =desk  (slav %tas desk.pole)
      ``noun+!>((~(get of store) [desk key.pole]))
    ::  existence
    ::
    ::  /desk
    ::
        [%x %u %desk desk=@ ~]
      ``noun+!>((~(has of store) /[desk.pole]))
    ::  /desk/key
    ::
        [%x %u %desk %key desk=@ key=*]
      =/  =desk  (slav %tas desk.pole)
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
  ++  on-watch  on-watch:def
  ++  on-agent  on-agent:def
  ++  on-arvo   on-arvo:def
  ++  on-leave  on-leave:def
  ++  on-fail   on-fail:def
  --
|_  =bowl:gall
+*  dup   =/  du  (du:sss update ,[* *])
          (du pubs bowl -:!>(*result:du))
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
  ::  XX remove?
  ::  our parent ship, if moon
  ~&  >  %checking-parent
  ?:  &((is-moon our.bowl) =(ship our-sponsor))
    `%w
  ::  explicitly set
  ~&  >  %checking-explicit
  =/  per=(unit perm)  +:(~(fit of roll) [desk (scot %p ship) key])
  ~&  >>>  per
  ?^  per
    u.per
  ::  our moons
  ~&  >  %checking-moons
  =/  per=(unit perm)  +:(~(fit of roll) [desk %moon key])
  ?:  &(?=(^ per) (our-moon ship))
    u.per
  ::  fellow moons
  ~&  >  %checking-fellow-moons
  =/  per=(unit perm)  +:(~(fit of roll) [desk %orbit key])
  ?:  ?&  ?=(^ per)
          (is-moon our.bowl)
          (same-sponsor ship our.bowl)
      ==
    u.per
  ~&  >  %checking-kids
  =/  per=(unit perm)  +:(~(fit of roll) [desk %kids key])
  ?:  &(?=(^ per) =(our.bowl (get-sponsor ship)))
    u.per
  ::  public
  ~&  >  %checking-public
  (fall +:(~(fit of roll) [desk %public key]) ~)
::
++  key-to-val
  |=  [=desk =key]
  ^-  (unit value)
  =/  val-key  (~(get of store) [desk key])
  ?~  val-key
    ~
  (~(get by objs) u.val-key)
::  XX
::
++  give-kicks
  |=  [=desk =key]
  ^+  pubs
  =/  subs=(list [paths=* [allowed=(unit (set ship)) *]])
    ~(tap by read:dup)
  ::|-  ^+  pubs
  ::?.  &(?=([desk=@ *] pole) =(desk desk.pole))
  ::  pubs
  ::?:  (can-read s desk key)
  ::  pubs
  ::=.  pubs  (block:dup [s ~] [desk pole]~)
  pubs
--
