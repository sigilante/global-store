#   `%global-store`

_a simple key-value storage solution for ship-global values_

`%global-store` intends to solve the problem of ship-wide configuration and
settings without any json compatibility overhead

it's simply a map for desks and keys to vases of values.

some things you could use it for:

- [`l10n`](https://github.com/sigilante/l10n) localization settings like
  preferred language or script or currency
- secret keys (pending urbit security)
- profile features beyond `%groups`

just set and scry

###### pokes

- `[%let =desk]` creates a desk key-value store (kvs)
- `[%lie =desk]` removes a desk kvs
- `[%put =desk =key =value]` puts a key in a desk's kvs (key is a vase)
- `[%del =desk =key]` removes a key
- `[%mode =arena =perm]` sets perms (see below)
- `[%whitelist =ship =perm]` add a ship to whitelist for perms (see below)
- `[%blacklist =ship]` removes a ship from whitelist (so not really a true blacklist)
- `[%lockdown ~]` removes all perms except yours

###### peeks

you can peek for a value at `/[desk]/[key]` which returns a `(unit vase)`

you can peek for all of a desk's values at `/[desk]` which returns a
`(unit (map @tas vase))`

###### subscriptions

you can subscribe to a value at `/[desk]/[key]` for a gift every time it changes

you can subscribe to all of a desk's values at `/[desk]` for a gift every time
any value changes

###### perms

there's not currently a per-agent permissions model altho i'm not averse to that

right now you can set perms by:

1. `%me` - always `%w` so you can write (`%w` implies `%r`)
2. `%team` - by default your team can `%w` write
3. `%whitelist` - you can add ships to a whitelist to `%r` read or `%w` write
4. `%public` - or you can let everyone `%r` read

###### some useful snippets

```hoon
=global -build-file /=global-store=/sur/global-store/hoon
:global-store &global-action [%let %example]
:global-store &global-action [%put %example %message !>('hello world')]
:global-store &global-action [%put %example %locale !>('en-US-Dsrt')]
:global-store +dbug
.^((unit (map @tas vase)) %gx /=global-store=/example/noun)
.^((unit vase) %gx /=global-store=/example/message/noun)
:global-store &global-action [%lie %example]
:global-store +dbug
```

###### status (wip ~2023.3.4)

- [x] main code (pokes, peeks) works
- [ ] test subs
- [ ] decide about return marks/units
- [ ] write generators to use pokes
- [ ] use whitelist for real tho

- [ ] version `%one` should rework perms to be per-desk instead of global
