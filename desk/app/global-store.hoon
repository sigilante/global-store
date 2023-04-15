  ::  global-store.hoon
::::
::    a simple key-value storage solution for ship-global values
::    with a straightforward permissions model
::
::    stores values as a (mip desk key vase)
::    returns values as (unit vase)
::
::    pokes:
::    %let - create a desk key-value store (kvs)
::    %lie - delete a desk kvs
::    %put - put a value with a key onto a desk's kvs
::    %del - delete a key in a desk's kvs
::    %mode - change access perms for the specified group
::    %whitelist - put a ship on the whitelist
::    %blacklist - remove a ship from the whitelist
::    %lockdown - set only self to read-write perms (by default team)
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
    =/  new-perms
      ^-  perms:gs
      %-  malt
      ^-  (list (pair arena:gs perm:gs))
      :~  :-  %public     *perm:gs
          :-  %whitelist  *perm:gs
          :-  %team       %r
          :-  %me         %w
      ==
    `this(perms new-perms)
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
        %noun  (on-poke:def mark vase)
    ::
        %global-store-action
      =+  !<(axn=action:gs vase)
      ?-    -.axn
      ::  when we produce a new desk key-value store, we "bunt" it w/ its name
      ::
          %let
        ?>  =(%w (what-perm:aux src:bowl))
        =.  store  (~(put bi store) desk.axn %name !>(desk.axn))
        :_  this  :_  ~
        :*  %give  %fact
            ~[`path`~[desk.axn]]
            %global-store-update
            !>(desk+(~(get by store) desk.axn))
        ==
      ::
          %lie
        ?>  =(%w (what-perm:aux src:bowl))
        :_  this(store (~(del by store) desk.axn))
        :~  :*  %give  %fact
                ~[`path`~[desk.axn]]
                %global-store-update
                !>(desk+(~(get by store) desk.axn))
        ==  ==
      ::
          %put
        ?>  =(%w (what-perm:aux src:bowl))
        =.  store  (~(put bi store) desk.axn key.axn value.axn)
        :_  this  :_  ~
        :*  %give  %fact
            ~[`path`~[desk.axn key.axn]]
            %global-store-update
            !>(desk+(~(get by store) desk.axn))
        ==
      ::
          %del
        ?>  =(%w (what-perm:aux src:bowl))
        =.  store  (~(del bi store) desk.axn key.axn)
        :_  this  :_  ~
        :*  %give  %fact
            ~[`path`~[desk.axn key.axn]]
            %global-store-update
            !>(value+~)
        ==
      ::
          %mode
        ?>  =(our src):bowl
        ::  not removing access or just myself
        ?:  ?|  !=(%$ perm.axn)
                =(%me arena.axn)
            ==
          `this(perms (~(put by perms) arena.axn perm.axn))
        ::  %$ for %team, %whitelist, %public
        :_  this(perms (~(put by perms) arena.axn perm.axn))
        ^-  (list card)
        %+  murn  ~(val by sup.bowl)
        |=  [=ship =path]
        ^-  (unit card)
        ?.  ?|  &(=(%team arena.axn) (moon:title our.bowl ship))
                &(=(%whitelist arena.axn) (~(has in whitelist) ship))
                =(%public arena.axn)
            ==
          ~
        `[%give %kick ~[path] `ship]
      ::
          %whitelist
        ?>  =(%w (what-perm:aux src:bowl))
        `this(whitelist (~(put in whitelist) ship.axn))
      ::
          %whitewash
        ::  XX kick
        ?>  =(%w (what-perm:aux src:bowl))
        `this(whitelist (~(del in whitelist) ship.axn))
      ::
          %lockdown
        ::  XX kick
        ?>  =(%w (what-perm:aux src:bowl))
        =/  empty-perms  
          ^-  perms:gs
          %-  malt
          ^-  (list (pair arena:gs perm:gs))
          :~  :-  %public     *perm:gs
              :-  %whitelist  *perm:gs
              :-  %team       *perm:gs
              :-  %me         %w
          ==
        `this(perms empty-perms, whitelist *whitelist:gs)
      ==  :: head tag
    ==  :: poke type
  ::
  ++  on-peek
    |=  =path
    ~>  %bout.[0 '%global-store +on-peek']
    ~&  >>  store
    ^-  (unit (unit cage))
    ?>  =(?(%r %w) (what-perm:aux src:bowl))
    ?+    path  (on-peek:def path)
    :: desk peek
    ::
        [%x @ ~]
      ~&  >>>  'desk scry'
      =/  =desk  (slav %tas i.t.path)
      ``noun+!>((~(get by store) desk))
    :: key peek
    ::
        [%x @ @ ~]
      =/  =desk    (slav %tas i.t.path)
      =/  =key:gs  (slav %tas i.t.t.path)
      ``noun+!>((~(get bi store) desk key))
    ==
  ::
  ++  on-agent  on-agent:def
  ++  on-arvo   on-arvo:def
  ++  on-watch
    |=  =path
    ~>  %bout.[0 '%global-store +on-watch']
    ~&  >>  store
    ^-  (quip card _this)
    :: on-watch, send them the value as a gift
    ?>  =(%r (what-perm:aux src:bowl))
    ?+    path  (on-watch:def path)
    :: desk subscription (not common), send all values in (unitized) desk ksv
    ::
        [@ ~]
      =/  =desk  (slav %tas i.path)
      :_  this  :_  ~
      [%give %fact ~ %noun !>((~(get by store) desk))]
    :: key subscription, just send the (unitized) value
    ::
        [@ @ ~]
      =/  =desk    (slav %tas i.path)
      =/  =key:gs  (slav %tas i.t.path)
      :_  this  :_  ~
      [%give %fact ~ %noun !>((~(get bi store) desk key))]
    ==
  ::
  ++  on-fail  on-fail:def
  ++  on-leave  on-leave:def
  --
|_  =bowl:gall
::  We check against the entire arena.
::
++  what-perm
  |=  =ship
  ^-  perm:gs
  ?:  =(our.bowl ship)
    (~(got by perms) %me)
  ?:  (moon:title our.bowl ship)
    (~(got by perms) %team)
  ?:  (~(has in whitelist) ship)
    (~(got by perms) %whitelist)
  (~(got by perms) %public)
--
