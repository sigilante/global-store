#   `%gs` global store

_a simple key-value storage solution for ship-global values_

_"making people behave like they care about integration by giving them easier inroads" (~rabsef-bicrym)_

`%gs` intends to solve the problem of ship-wide configuration and
settings without any json compatibility overhead

it's simply a map for desks and keys to vases of values.

some things you could use it for:

- localization settings
- visual preferences (dark mode)
- secret keys (pending hardened urbit security)
- profile features beyond `%groups`

just set and scry (or subscribe)

###### pokes

- `%put` - put a value with a key onto a desk's kvs
- `%del` - delete a key in a desk's kvs (rm)
- `%lop` - delete keys in a desk's kvs (rm -r)
::
- `%enroll` - put an arena on the roll
- `%unroll` - remove an arena from the roll
- `%lockdown` - set only self to read-write perms for a desk

###### peeks

- `/x/desk/[desk]`
- `/x/desk/key/[desk]/[key]`
- `/x/u/desk/[desk]` existence check
- `/x/u/desk/key/[desk]/[key]` existence check

###### subscriptions

- `/desk/[desk]`
- `/desk/key/[desk]/[key]`
- `/u/desk/[desk]`
- `/u/desk/key/[desk]/[key]`

###### perms

right now you can set perms by:

- `%moon` - moons if you're a planet
- `%orbit` - moons under same parent (if you're a moon)
- `%kids` - sponsees (azimuth sense)
- `%public` - free for all
- `%ship` - whitelist

set types:

- `%r` - read
- `%w` - write

###### some useful snippets

```hoon
=gs -build-file /=gs=/sur/gs/hoon
::
:gs|put       ::  :gs|put %desk /key/to noun+!>(42)
:gs|del       ::  :gs|del %desk /key/to
:gs|lop       ::  :gs|lop %desk /key/to
::
:gs|enroll    ::  :gs|enroll %desk /key/to arena perm
:gs|unroll    ::  :gs|unroll %desk /key/to arena :gs|lockdown  ::  :gs|lockdown %desk
::
:gs +dbug
```

###### changelog

- `[1 0 0]` first public release, pokes/peeks/subs
- `[1 1 0]` added a rudimentary mast front-end at /gs

- todo:  clean up and add deletion
