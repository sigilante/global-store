/-  *gs
|=  [bol=bowl:gall =store =roll =objs]
|^  ^-  manx
::
:: tr
::  td
::   /path/to/key
::   value-at-path
::  td
::   /new/path/entry
::   [ v] <- mark types
::   [  ] <- cage
;html
  ;head
    ;meta(charset "utf-8");
    ;link(href "https://fonts.googleapis.com/css2?family=Inter:wght@400;600&family=Source+Code+Pro:wght@400;600&display=swap", rel "stylesheet");
    ;link(href "/gs/style", rel "stylesheet");
  ==
  ;body
    ;+  kv-table
  ==
==
::
++  kv-table
  ^-  manx
  ;div.content
    ;table.store
      ;*  %+  turn  `(list (pair key @uvI))`~(tap of store)
        |=  [key=key hax=@uvI]
        ;tr
          ;td:"{<key>}"
          ;td:"<(~(got by hax) objs)>"
        ==
    ==
  ==
::
--
