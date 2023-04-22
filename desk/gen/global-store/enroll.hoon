::  :global-store|enroll arena perm %desk /foo
::    :global-store|enroll [%ship ~zod] `%r %kids /foo
::
/-  gs=global-store
:-  %say
|=  $:  ^
        [=arena:gs =perm:gs =desk key=path ~]
        ~
    ==
[%global-store-action [%enroll arena perm desk key]]
