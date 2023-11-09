::  :global-store|enroll %desk /foo arena perm
::    :global-store|enroll %kids /foo [%ship ~zod] `%r
::
/-  *global-store
:-  %say
|=  $:  ^
        [=desk =key =arena =perm ~]
        ~
    ==
[%global-store-action [%enroll desk key arena perm]]
