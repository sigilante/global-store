::  :global-store|unroll %desk /foo arena 
::    :global-store|unroll %kids /foo [%ship ~zod]
::
/-  *global-store
:-  %say
|=  $:  ^
        [=desk =key =arena ~]
        ~
    ==
[%global-store-action [%unroll desk key arena]]
