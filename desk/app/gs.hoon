  ::  /app/gs.hoon
::::  ~lagrev-nocfep & ~midden-fabler
::    Version ~2023.12.5
::
::    GLOBAL STORE
::
::    a simple key-value storage solution for ship-global values
::    with a straightforward permissions model
::
::    permissions are stored as an (axal perm)
::    keys are stored as an (axal @uvI)
::    objects are stored as a (map @uvI vase)
::    references are stored as a (jug @uvI path)
::    returns values as (unit cage)
::
::    pokes:
::
::    %put - put a value with a key onto a desk's kvs
::    %del - delete a key in a desk's kvs (rm)
::    %lop - delete keys in a desk's kvs (rm -r)
::
::    %enroll - put an arena on the roll
::    %unroll - remove an arena from the roll
::    %lockdown - set only self to read-write perms for a desk
::
::    your basic use pattern will be to put important global
::    values into your desk's store with `%put`
::    or to read out an important value by peeking or subscribing and
::    receiving a gift in return
::
::    for a value you'll peek to
::    /x/desk/[desk]
::    /x/desk/key/[desk]/[key]
::    /x/u/desk/[desk]
::    /x/u/desk/key/[desk]/[key]
::
::    or subscribe to
::    /desk/[desk]
::    /desk/key/[desk]/[key]
::
::    the advantage of subscribing is that you receive changes to the value
::
/-  *gs,
    update
/+  agentio,
    dbug,
    default-agent,
    mast,
    verb
/=  index  /app/gs/index
/=  style  /app/gs/style
=>
  |%
  +$  card  $+(card card:agent:gall)
  +$  versioned-state
    $%  state-0
        state-1
        state-2
        state-3
        state-4
    ==
  +$  state-0
    $:  %0
        =store  =roll  =objs  =refs
    ==
  +$  state-1
    $:  %1
        =store  =roll  =objs  =refs
        =view:mast   url=path
    ==
  +$  state-2
    $:  %2
        =store  =roll  =objs  =refs
        =view:mast   url=path
        input-reset=?  selected-desks=(set @t)
    ==
  +$  state-3
    $:  %3
        =store  =roll  =objs  =refs
    ==
  +$  state-4
    $:  %4
        =store  =roll  =objs  =refs  =txts
    ==
  +$  front-end
    $:  =view:mast   url=path
        input-reset=?  selected-desks=(set @t)
        edit-mode=$~(%.n ?)
    ==
  --
=|  [state-4 front-end]
=*  state  -
%+  verb  &
%-  agent:dbug
^-  agent:gall
=<
  |_  =bowl:gall
  +*  this  .
      def   ~(. (default-agent this %|) bowl)
      io    ~(. agentio bowl)
      aux   ~(. +> bowl)
      ::  XX this is a weird spot
      routes  %-  limo
      :~  [/gs index]
      ==
  ++  on-init
    ^-  (quip card _this)
    :_  this
    :~  (~(arvo pass:io /bind) %e %connect `/gs %gs)
    ==
  ++  on-save  !>(-.state)
  ++  on-load
    |=  =vase
    ^-  (quip card _this)
    =/  old  !<(versioned-state vase)
    ?-    -.old
        %0
      :_  this(state [[%4 store.old roll.old objs.old refs.old *^txts] *front-end])
      :~  (~(arvo pass:io /bind) %e %connect `/gs %gs)
      ==
        %1
      [~ this(state [[%4 store.old roll.old objs.old refs.old *^txts] *front-end])]
        %2
      [~ this(state [[%4 store.old roll.old objs.old refs.old *^txts] *front-end])]
        %3
      [~ this(state [[%4 store.old roll.old objs.old refs.old *^txts] *front-end])]
        %4
      [~ this(state [old *front-end])]
    ==
  ++  on-poke
    |=  [=mark =vase]
    |^  ^-  (quip card _this)
    ?+    mark  (on-poke:def mark vase)
        %gs-action
      =+  !<(act=action vase)
      ?-    -.act
          %put
        =^  cards  state  (put act)
        [cards this]
      ::
          %del
        =/  hash=(unit @uvI)  (~(get of store) [desk.act key.act])
        =?  txts  ?=(^ hash)  (~(del by txts) u.hash)
        =^  cards  state  (del act)
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
        :_  this
        ::  return desk empty, all keys empty, all key /u false, kicks
        ;:  welp
          (cull-keys [desk.act key.act])
          (give-updates desk.act)
          (give-kicks desk.act)
          :~  [%give %fact ~[[%desk desk.act ~]] %update !>(desk+(export-values desk.act))]
              [%give %fact ~[[%u %desk desk.act ~]] %update !>(has-desk+[desk.act (~(has of store) /[desk.act])])]
          ==
        ==
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
        [~ this]
      ::
          %lockdown
        ?>  (can-change-roll:aux src.bowl)
        =.  roll  (~(lop of roll) /[desk.act])
        ::  XX  all paths
        [~ this]
      ==
      ::
        %handle-http-request
      |^  (handle-http !<([@ta inbound-request:eyre] vase))
      ++  handle-http
        |=  [eyre-id=@ta req=inbound-request:eyre]
        ^-  (quip card _this)
        ?.  authenticated.req
          [(make-auth-redirect:mast eyre-id) this]
        ?+    method.request.req  [(make-400:mast eyre-id) this]
            %'GET'
          =/  url=path  (stab url.request.req)
          ?:  =(/gs/style url)
            [(make-css-response:mast eyre-id style) this]
          =/  new-view=manx
            (rig:mast routes url [bowl store objs txts input-reset selected-desks edit-mode])
          :-  (plank:mast "gs" /display-updates our.bowl eyre-id new-view)
          this(view new-view, url url)
        ==
      --
      ::
        %json
      ?>  =(our.bowl src.bowl)
      |^  (handle-client-poke !<(json vase))
      ++  handle-client-poke
        |=  json-req=json
        ^-  (quip card _this)
        =/  client-poke  (parse-json:mast json-req)
        ?+    tags.client-poke  ~|(%bad-ui-poke [~ this])
            [%click %submit-form ~]
          :: get input values:
          =/  dest  (~(got by data.client-poke) '/kv-desk/value')
          =/  patt  (~(got by data.client-poke) '/kv-path/value')
          =/  mart  (~(got by data.client-poke) '/kv-mark/value')
          =/  valt  (~(got by data.client-poke) '/kv-value/value')
          ?:  |(=(~ dest) =(~ patt) =(~ mart))
            ~&('empty input on submit' !!)
          =?  dest  =('%' -:(trip dest))
            (crip +:(trip dest))
          =?  mart  =('%' -:(trip mart))
            (crip +:(trip mart))
          ?.  ((sane %tas) dest)
            ~&('desk input not valid' !!)
          ?.  ((sane %tas) mart)
            ~&('mark input not valid' !!)
          =/  des=@tas  dest
          =/  mar=@tas  mart
          =/  pax=path  (stab patt)
          =/  val  (slap !>(~) (ream valt))
          ~&  >  des
          ~&  >  pax
          ~&  >  mar
          ~&  >>  val
          =^  cards  state  (put [%put des pax [mar val]])
          =:  txts  (~(put by txts) `@uvI`(shax (jam [mar val])) valt)
              input-reset  !input-reset
            ==
          =/  new-view=manx
            (rig:mast routes url [bowl store objs txts input-reset selected-desks edit-mode])
          :-  [(gust:mast /display-updates view new-view) cards]
          this(state state(view new-view))
          ::
            [%click %select-desk ~]
          =/  desk-name=@t  (~(got by data.client-poke) '/target/id')
          =.  selected-desks
            ?:  (~(has in selected-desks) desk-name)
              (~(del in selected-desks) desk-name)
            (~(put in selected-desks) desk-name)
          =/  new-view=manx
            (rig:mast routes url [bowl store objs txts input-reset selected-desks edit-mode])
          :-  [(gust:mast /display-updates view new-view) ~]
          this(view new-view)
          ::
            [%click %select-all-desks ~]
          =.  selected-desks
            %+  ^^roll  `(list (pair key @uvI))`~(tap of store)
            |=  [v=(pair key @uvI) a=(set @t)]
            ?~  p.v  a
            (~(put in a) i.p.v)
          =/  new-view=manx
            (rig:mast routes url [bowl store objs txts input-reset selected-desks edit-mode])
          :-  [(gust:mast /display-updates view new-view) ~]
          this(view new-view)
          ::
            [%click %hide-all-desks ~]
          =.  selected-desks  ~
          =/  new-view=manx
            (rig:mast routes url [bowl store objs txts input-reset selected-desks edit-mode])
          :-  [(gust:mast /display-updates view new-view) ~]
          this(view new-view)
          ::
            [%click %toggle-edit-mode ~]
          =.  edit-mode  !edit-mode
          =/  new-view=manx
            (rig:mast routes url [bowl store objs txts input-reset selected-desks edit-mode])
          :-  [(gust:mast /display-updates view new-view) ~]
          this(view new-view)
          ::
            [%click %delete ~]
          =/  keyt  (~(got by data.client-poke) '/target/id')
          =/  keyp=path  (stab keyt)
          ?~  keyp  ~&('missing delete path from ui' [~ this])
          =/  hash=(unit @uvI)  (~(get of store) keyp)
          =^  cards  state  (del [%del keyp])
          =?  txts  ?=(^ hash)  (~(del by txts) u.hash)
          =/  new-view=manx
            (rig:mast routes url [bowl store objs txts input-reset selected-desks edit-mode])
          :-  [(gust:mast /display-updates view new-view) cards]
          this(state state(view new-view))
        ==
      --
    ==
    ++  put
      |=  [%put =desk =key =value]
      ^-  (quip card _state)
      ?>  (can-write:aux src.bowl desk key)
      =/  hash=@uvI  (shax (jam value))
      =/  old-hash   (~(get of store) [desk key])
      ?:  &(?=(^ old-hash) =(hash u.old-hash))
        [~ state]
      =.  store  (~(put of store) [desk key] hash)
      =.  refs   (~(put ju refs) hash [desk key])
      =?  refs  &(?=(^ old-hash) !=(u.old-hash hash))
        (~(del ju refs) u.old-hash [desk key])
      =?  objs  !(~(has by objs) hash)
        (~(put by objs) hash value)
      =?  objs  &(?=(^ old-hash) =(~ (~(get ju refs) u.old-hash)))
        (~(del by objs) u.old-hash)
      =/  =path  [desk key]
      :_  state
      :~  [%give %fact ~[[%desk desk ~]] %update !>(desk+(export-values desk))]
          [%give %fact ~[[%u %desk desk ~]] %update !>(has-desk+[desk &])]
          [%give %fact ~[[%u %desk %key desk key]] %update !>(has-key+[desk key &])]
          [%give %fact ~[[%desk %key desk key]] %update !>(value+value)]
      ==
    ++  del
      |=  [%del =desk =key]
      ^-  (quip card _state)
      ?>  (can-write:aux src.bowl desk key)
      =/  hash=(unit @uvI)  (~(get of store) [desk key])
      =.  store  (~(del of store) [desk key])
      =?  refs  ?=(^ hash)
        (~(del ju refs) u.hash [desk key])
      =?  objs  &(?=(^ hash) =(~ (~(get ju refs) u.hash)))
        (~(del by objs) u.hash)
      :_  state
      :~  [%give %fact ~[[%desk desk ~]] %update !>(desk+(export-values desk))]
          [%give %fact ~[[%u %desk %key desk key]] %update !>(has-key+[desk key |])]
          [%give %fact ~[[%desk %key desk key]] %update !>(value+~)]
      ==
    --
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
    ::  permissions
    ::
        [%x %roll ~]  ``noun+!>(roll)
    ::
        [%x %perm %ship %desk %key ship=@ desk=@ key=*]
      =/  =desk  (slav %tas desk.pole)
      =/  =ship  (slav %p ship.pole)
      =/  =key   ;;(key key.pole)
      ``noun+!>((what-perm:aux ship desk key))
    ==
  ++  on-watch
    |=  =(pole knot)
    ^-  (quip card _this)
    ?+    pole  (on-watch:def pole)
    ::  /http-response
    ::
        [%http-response *]
      ?>  =(our.bowl src.bowl)
      [~ this]
    ::  /display-updates
    ::
        [%display-updates *]
      ?>  =(our.bowl src.bowl)
      [~ this]
    ::  /desk
    ::
        [%desk desk=@ ~]
      =/  response  (export-values desk.pole)
      :_  this
      :~  [%give %fact ~ %update !>(desk+response)]
      ==
    ::  /desk/key
    ::
        [%desk %key desk=@ key=*]
      ?.  (can-read src.bowl desk.pole key.pole)
        [~ this]
      =/  response  (key-to-val desk.pole key.pole)
      :_  this
      :~  [%give %fact ~ %update !>(value+response)]
      ==
    ::  /u/desk
    ::
        [%u %desk desk=@ ~]
      =/  response  (~(has of store) /[desk.pole])
      :_  this
      :~  [%give %fact ~ %update !>(has-desk+response)]
      ==
    ::  /u/desk/key
    ::
        [%u %desk %key desk=@ key=*]
      ?.  (can-read src.bowl desk.pole key.pole)
        [~ this]
      =/  response  (~(has of store) desk.pole key.pole)
      :_  this
      :~  [%give %fact ~ %update !>(has-key+[desk.pole key.pole response])]
      ==
    ==
  ++  on-agent  on-agent:def
  ++  on-arvo
    |=  [wire=(pole knot) =sign-arvo]
    ^-  (quip card _this)
    ?+    sign-arvo  ~|(%bad-arvo-sign [~ this])
        [%eyre %bound *]
      [~ this]
    ==
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
++  export-values
  |=  [=desk]
  ^-  (map key value)
  =/  all-keys-hashes  ~(tap of store)
  =/  keys-hashes
    %+  murn  all-keys-hashes
    |=  [=path hash=@uvI]
    ?.  =(desk -.path)  ~
    ?.  (can-read src.bowl desk (tail path))  ~
    `[path hash]
  *(map key value)
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
  ?~(val-key ~ (~(get by objs) u.val-key))
++  give-kicks
  |=  =desk
  ^-  (list card)
  %+  murn  ~(val by sup.bowl)
  |=  [=ship =(pole knot)]
  ^-  (unit card)
  ?.  &(?=([desk=@ *] pole) =(desk desk.pole))
    ~
  ?:  (can-read ship pole)
    ~
  `[%give %kick [pole ~] `ship]
++  cull-keys
  |=  [=desk =key]
  ^-  (list card)
  %-  zing
  %+  murn  ~(val by sup.bowl)
  |=  [=ship =(pole knot)]
  ^-  (unit (list card))
  ?.  &(?=([desk=@ *] pole) =(desk desk.pole))
    ~
  ?:  (can-read ship pole)
    ~
  :-  ~
  :~  [%give %fact ~[`path`[%u %desk %key desk key]] %update !>(has-key+[desk key |])]
      [%give %fact ~[`path`[%desk %key desk key]] %update !>(value+~)]
  ==
::
++  give-updates
  |=  arg=$@(=desk [=desk =key])
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
      |=  =key
      (value-update desk.arg key)
  ::
  ++  desk-keys
    |=  =desk
    ^-  (set key)
    %-  sy
    %+  murn  ~(val by sup.bowl)
    |=  [* =(pole knot)]
    ?.  &(?=([desk=@ key=*] pole) =(desk.pole desk))
      ~
    `key.pole
  ::
  ++  desk-update
    |=  =desk
    ^-  card
    :*  %give  %fact  ~[/desk/[desk]]
        %update
        !>(desk+(export-values desk))
    ==
  ::
  ++  value-update
    |=  [=desk =key]
    ^-  card
    :*  %give  %fact  ~[:(welp /desk/key /[desk] key)]
        %update
        !>(`^update`[value+(key-to-val desk key)])
    ==
  --
--
