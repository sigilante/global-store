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
/-  global=global-store
/+  verb, dbug, default-agent, *mip
::
|%
::
+$  versioned-state  $%(state-zero)
::
+$  state-zero  [%zero =store:global =perms:global =whitelist:global]
::
::
::  boilerplate
::
+$  card  card:agent:gall
--
::
%+  verb  &
%-  agent:dbug
=|  state-zero
=*  state  -
::
^-  agent:gall
::
|_  =bowl:gall
+*  this  .
    def   ~(. (default-agent this %|) bowl)
++  on-init
  ^-  (quip card _this)
  ~>  %bout.[0 '%global-store +on-init']
  ~&  >>  store
  =/  new-perms  ^-  perms:global  %-  malt
  ^-  (list (pair arena:global perm:global))
  :~  :-  %public     *perm:global
      :-  %whitelist  *perm:global
      :-  %team       %r
      :-  %me         %w
  ==
  :-  ~
      this(store *store:global, perms new-perms, whitelist *whitelist:global)
::
++  on-save
  ^-  vase
  ~>  %bout.[0 '%global-store +on-save']
  ~&  >>  store
  !>(state)
::
++  on-load
  |=  ole=vase
  ^-  (quip card _this)
  ~&  >>  store
  =/  old  !<(versioned-state ole)
  ?-  -.old
    %zero  `this(state old)
  ==
::
++  on-poke
  |=  [mar=mark vaz=vase]
  ~>  %bout.[0 '%global-store +on-poke']
  ~&  >>  store
  ^-  (quip card _this)
  ?+    mar  (on-poke:def mar vaz)
      %noun
    (on-poke:def mar vaz)
      %global-store-action
    =+  !<(axn=action:global vaz)
    ?-    -.axn
        %let
      ::  when we produce a new desk key-value store, we "bunt" it w/ its name
      :_  this(store (~(put bi store) desk.axn %name !>(desk.axn)))
      :~  :*  %give  %fact
              ~[`path`~[desk.axn]]
              %global-store-update
              !>(desk+(~(get by store) desk.axn))
          ==
      ==
      ::
        %lie
      =/  keys  ~(tap in (~(key bi store) desk.axn))
      =/  new-store  store
      =/  idx   0
      ::  recursively delete all entries for the desk
      :_  %=  this
          store
            |-  ?:  =((lent keys) idx)  new-store
            =/  key  (snag idx keys)
            $(idx +(idx), new-store (~(del bi store) desk.axn key))
          ==
      :~  :*  %give  %fact
              ~[`path`~[desk.axn]]
              %global-store-update
              !>(desk+~)
          ==
      ==
      ::
        %put
      :_  this(store (~(put bi store) desk.axn key.axn value.axn))
      :~  :*  %give  %fact
              ~[`path`~[desk.axn key.axn]]
              %global-store-update
              !>(desk+(~(get by store) desk.axn))
          ==
      ==
      ::
        %del
      :_  this(store (~(del bi store) desk.axn key.axn))
      :~  :*  %give  %fact
              ~[`path`~[desk.axn key.axn]]
              %global-store-update
              !>(value+~)
          ==
      ==
      ::
        %mode
      :-  ~
          this(perms (~(put by perms) arena.axn perm.axn))
      ::
        %whitelist
      :-  ~
          this(whitelist (~(put by whitelist) ship.axn perm.axn))
      ::
        %blacklist
      :-  ~
          this(whitelist (~(del by whitelist) ship.axn))
      ::
        %lockdown
      =/  empty-perms  ^-  perms:global  %-  malt
      ^-  (list (pair arena:global perm:global))
      :~  :-  %public     *perm:global
          :-  %whitelist  *perm:global
          :-  %team       *perm:global
          :-  %me         %w
      ==
      :-  ~
          this(perms empty-perms, whitelist *(map ship:global perm:global))
      ::
    ==  :: head tag
  ==  :: poke type
::
++  on-peek
  |=  =path
  ~>  %bout.[0 '%global-store +on-peek']
  ~&  >>  store
  ^-  (unit (unit cage))
  ?+    path  (on-peek:def path)
      [%x @ ~]
    :: desk peek
    ~&  >>>  'desk scry'
    =/  =desk:global  (slav %tas i.t.path)
    [~ ~ noun+!>((~(get by store) desk))]
      [%x @ @ ~]
    :: key peek
    =/  =desk:global  (slav %tas i.t.path)
    =/  =key:global   (slav %tas i.t.t.path)
    [~ ~ noun+!>((~(get bi store) desk key))]
  ==  :: path
::
++  on-agent
  |=  [wir=wire sig=sign:agent:gall]
  ~>  %bout.[0 '%global-store +on-agent']
  ^-  (quip card _this)
  `this
::
++  on-arvo
  |=  [wir=wire sig=sign-arvo]
  ~>  %bout.[0 '%global-store +on-arvo']
  ^-  (quip card _this)
  `this
::
++  on-watch
  |=  =path
  ~>  %bout.[0 '%global-store +on-watch']
  ~&  >>  store
  ^-  (quip card _this)
  :: on-watch, send them the value as a gift
  ?+    path  (on-watch:def path)
      [@ ~]
    :: desk subscription (not common), send all values in (unitized) desk ksv
    =/  =desk:global  (slav %tas i.path)
    :_  this
    :~  [%give %fact ~ %noun !>((~(get by store) desk))]
    ==
    ::
      [@ @ ~]
    :: key subscription, just send the (unitized) value
    =/  =desk:global  (slav %tas i.path)
    =/  =key:global   (slav %tas i.t.path)
    :_  this
    :~  [%give %fact ~ %noun !>((~(get bi store) desk key))]
    ==
  ==  :: path
::
++  on-fail
  ~>  %bout.[0 '%global-store +on-fail']
  on-fail:def
::
++  on-leave
  ~>  %bout.[0 '%global-store +on-leave']
  on-leave:def
--
