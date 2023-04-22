::  :global-store|put %desk /key noun+!>(42)
::
/-  gs=global-store
:-  %say
|=  $:  ^
        [=desk key=path =value:gs ~]
        ~
    ==
[%global-store-action [%put desk key value]]
