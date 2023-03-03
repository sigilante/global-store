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
::    or to read out an important value by subscribing and
::    receiving a gift in return
::    you'll subscribe to /[desk]/[key] for a value
::
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
=<
  |_  =bowl:gall
  +*  this  .
      def   ~(. (default-agent this %|) bowl)
      aux   ~(. +> [bowl ~])
  ++  on-init
    ^-  (quip card _this)
    ~>  %bout.[0 '%global-store +on-init']
    =/  new-arena  %-  malt
    ^-  (list (pair arena:global perm:global))
    :~  :-  %public     *perm
        :-  %whitelist  *perm
        :-  %team       %r
        :-  %me         %w
    ==
    :_  this(arena new-arena)
        ~
  ::
  ++  on-save
    ^-  vase
    ~>  %bout.[0 '%global-store +on-save']
    !>(state)
  ::
  ++  on-load
    |=  ole=vase
    ^-  (quip card _this)
    =/  old  !<(versioned-state ole)
    ?-  -.old
      %zero  `this(state old)
    ==
  ::
  ++  on-poke
    |=  [mar=mark vaz=vase]
    ~>  %bout.[0 '%global-store +on-poke']
    ^-  (quip card _this)
    ?+    mar  (on-poke:def mar vaz)
        %noun
      (on-poke:def mar vaz)
        %global-action
      =+  !<(axn=action vaz)
      ?-    -.axn
          %let
        ::  when we produce a new desk key-value store, we "bunt" it w/ its name
        :_  this(store (~(put bi store) desk.axn %name !>(desk)))
        :~  :*  %give  %fact
                ~[`path`~[desk]]
                %global-update
                !>(desk+(~(get by store) desk))
            ==
        ==
        ::
          %lie
        =/  desk  +.axn
        =/  keys  ~(tap in (~(key bi store) desk))
        =/  new-store  store
        =/  idx   0
        ::  recursively delete all entries for the desk
        :_  %=  store
              |-  ?:  =((lent keys) idx)  new-store
              =/  key  (snag idx keys)
              $(idx +(idx), new-store (~(del bi store) desk key))
            ==
        :~  :*  %give  %fact
                ~[`path`~[desk]]
                %global-update
                !>(desk+~)
            ==
        ==
        ::
          %put
        :_  this((~(put bi store) desk.axn key.axn value.axn))
        :~  :*  %give  %fact
                ~[`path`~[desk key]]
                %global-update
                !>(desk+(~(get by store) desk))
            ==
        ==
        ::
          %del
        :_  this(store (~(del bi store) desk.axn key.axn))
        :~  :*  %give  %fact
                ~[`path`~[desk key]]
                %global-update
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
        =/  emptylist  %-  malt
        ^-  (list (pair arena:global perm:global))
        :~  :-  %public     *perm
            :-  %whitelist  *perm
            :-  %team       *perm
            :-  %me         %w
        ==
        :-  ~
            this(whitelist emptylist)
        ::
      ==  :: head tag
    ==  :: poke type
  ::
  ++  on-peek
    :: just let %opal handle all peeks
    |=  =path
    ~>  %bout.[0 '%global-store +on-peek']
    ^-  (unit (unit cage))
    [~ ~]
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
    ^-  (quip card _this)
    :: on-watch, send them the value as a gift
    ?+    path  (on-watch:def path)
        [@ ~]
      :: desk subscription (not common), send all values in (unitized) desk ksv
      =/  =desk  (slav %tas i.path)
      :_  this
      :~  [%give %fact ~ %global-update !>(desk+(~(get by store) desk))]
      ==
      ::
        [@ @ ~]
      :: key subscription, just send the (unitized) value
      =/  =desk  (slav %tas i.path)
      =/  =key   (slav %tas t.path)
      :_  this
      :~  [%give %fact ~ %global-update !>(desk+(~(get by store) desk key))]
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
|_  =bowl:gall
++  parse  !!
--
