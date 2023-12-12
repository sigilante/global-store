/-  *gs
|=  [bol=bowl:gall =store =objs input-reset=? selected-desks=(set @t)]
|^  ^-  manx
::
;html
  ;head
    ;meta(charset "utf-8");
    ;link(href "https://fonts.googleapis.com/css2?family=Metamorphous&display=swap", rel "stylesheet");
    ;link(href "/gs/style", rel "stylesheet");
  ==
  ;body
    ;h1(class "title"): Global Store
    ;+  gs-form
    ;+  all-desks
  ==
==
::
++  gs-form
  ^-  manx
  ;div(class "gs-form")
    ;label
      ;+  ;/  "Desk:"
      ;input#kv-desk(placeholder "%desk", key "{<input-reset>}desk");
    ==
    ;label
      ;+  ;/  "Path:"
      ;input#kv-path(placeholder "/path", key "{<input-reset>}path");
    ==
    ;label
      ;+  ;/  "Mark:"
      ;input#kv-mark(placeholder "%mark", key "{<input-reset>}mark");
    ==
    ;label
      ;+  ;/  "Value:"
      ;input#kv-value(placeholder "value", key "{<input-reset>}value");
    ==
    ;button
      =event  "/click/submit-form"
      =return  "/kv-desk/value /kv-path/value /kv-mark/value /kv-value/value"
      ;+  ;/  "Create"
    ==
  ==
::
++  all-desks
  ^-  manx
  ;div(class "desks-container")
    ;*  %+  turn  kvs-by-desk
      |=  [desk=@t kvs=(list (pair key @uvI))]
      ;div
        =class  "desk"
        =key  "desk-{(trip desk)}"
        ;div
          =id  (trip desk)
          =class  "desk-selector"
          =event  "/click/select-desk"
          =return  "/target/id"
          ;+  ;/  "%{(trip desk)}"
        ==
        ;+  (kv-table kvs)
      ==
  ==
::
++  kv-table
  |=  kvs=(list (pair key @uvI))
  ^-  manx
  ;div(class "kv-table")
    ;*  %+  turn  kvs
      |=  [key=key hax=@uvI]
      =/  val=cage  (~(got by objs) hax)
      =/  name=tape  ?~(key "" ?~(t.key "" (trip i.t.key)))
      ;div
        =class  "kv-item"
        =key  "{(path key)}"
        ;div(class "kv-name"): {name}
        ;div
          ;div: {<p.val>}
          ;div: {<p.q.val>}
          ;div: {<q.q.val>}
        ==
      ==
  ==
::
:: produces a list of each unique desk in the store's keys
++  each-desk
  ^-  (list @t)
  %~  tap  in
  %+  ^roll  `(list (pair key @uvI))`~(tap of store)
  |=  [v=(pair key @uvI) a=(set @t)]
  ?~  p.v
    a
  (~(put in a) i.p.v)
::
:: produces a list of the store's kv pairs organized by each desk.
:: only the desks which are selected have their list populated with kvs.
++  kvs-by-desk
  ^-  (list [desk=@t kvs=(list (pair key @uvI))])
  =/  acc=(list [desk=@t kvs=(list (pair key @uvI))])
    %+  turn  each-desk  |=(d=@t [d ~])
  =/  sto=(list (pair key @uvI))  ~(tap of store)
  |-
  ?~  sto
    acc
  ?.  &(?=(^ p.i.sto) (~(has in selected-desks) i.p.i.sto))
    $(sto t.sto)
  =/  nacc=(list [@t (list (pair key @uvI))])
    |-
    ?~  sto  !!
    ?~  acc
      ~
    ?:  =(desk.i.acc i.p.i.sto)
      [[desk.i.acc [i.sto kvs.i.acc]] $(acc t.acc)]
    [i.acc $(acc t.acc)]
  $(sto t.sto, acc nacc)
::
--
