::  :global-store|unroll arena %desk /foo
::    :global-store|unroll [%ship ~zod] %kids /foo
::
/-  gs=global-store
:-  %say
|=  $:  ^
        [=arena:gs =desk key=path ~]
        ~
    ==
[%global-store-action [%unroll arena desk key]]
