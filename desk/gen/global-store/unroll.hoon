::  :global-store|unroll whom:gs %desk key=path
::    :global-store|unroll `~zod %desk /
::    :global-store|unroll %moon %desk /config
::  
::
/-  gs=global-store
:-  %say
|=  $:  ^
        [=whom:gs =desk key=path ~]
        ~
    ==
[%global-store-action [%unroll whom desk key]]
