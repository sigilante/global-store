::  :global-store|enroll whom:gs %desk key=path perm:gs
::    :global-store|enroll `~zod %desk / `%w
::    :global-store|enroll %moon %desk /config `%r
::  
::
/-  gs=global-store
:-  %say
|=  $:  ^
        [=whom:gs =desk key=path =perm:gs ~]
        ~
    ==
[%global-store-action [%enroll whom desk key perm]]
