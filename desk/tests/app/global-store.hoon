/-  global=global-store
/+  *test, *mip
/=  agent  /app/global-store
|%
::  Build an example bowl manually.
::
++  bowl
  |=  run=@ud
  ^-  bowl:gall
  :*  [~zod ~zod %global-store] :: (our src dap)
      [~ ~]                     :: (wex sup)
      [run `@uvJ`(shax run) *time [~zod %global-store ud+run]]
                                :: (act eny now byk)
  ==
::  Build a reference state mold.
::
+$  state
  $:  %zero
      =store:global
      =perms:global
      =whitelist:global
  ==
--
|%
++  test-add-single-desk
  =|  run=@ud
  =^  move  agent  (~(on-poke agent (bowl run)) %global-store-update !>([%let %surf]))
  =+  !<(=state on-save:agent)
  ;:  weld
  %+  expect-eq
    !>  :*  %zero
            store=(~(put bi store) %surf %name !>(%surf))
            perms=*perms:global
            whitelist=*whitelist:global
        ==
    !>  state
  ==
++  test-add-two-desks
  =|  run=@ud
  =^  move  agent  (~(on-poke agent (bowl run)) %global-store-update !>([%let %surf]))
  =^  move  agent  (~(on-poke agent (bowl run)) %global-store-update !>([%let %turf]))
  =+  !<(=state on-save:agent)
  ;:  weld
  %+  expect-eq
    =|  sto=store:global
    =/  sto  (~(put bi sto) %surf %name !>(%surf))
    =/  sto  (~(put bi sto) %turf %name !>(%turf))
    !>  :*  %zero
            store=sto
            perms=*perms:global
            whitelist=*whitelist:global
        ==
    !>  state
  ==
++  test-delete-desk
  =|  run=@ud
  =^  move  agent  (~(on-poke agent (bowl run)) %global-store-update !>([%let %surf]))
  =^  move  agent  (~(on-poke agent (bowl run)) %global-store-update !>([%let %turf]))
  =^  move  agent  (~(on-poke agent (bowl run)) %global-store-update !>([%lie %surf]))
  =+  !<(=state on-save:agent)
  ;:  weld
  %+  expect-eq
    =|  sto=store:global
    =/  sto  (~(put bi sto) %surf %name !>(%surf))
    =/  sto  (~(put bi sto) %turf %name !>(%turf))
    =/  sto  (~(del bi sto) %surf %name)
    !>  :*  %zero
            store=sto
            perms=*perms:global
            whitelist=*whitelist:global
        ==
    !>  state
  ==
++  test-add-values-to-desk
  =|  run=@ud
  =^  move  agent  (~(on-poke agent (bowl run)) %global-store-update !>([%let %home]))
  =^  move  agent  (~(on-poke agent (bowl run)) %global-store-update !>([%put %home %city 'Champaign']))
  =^  move  agent  (~(on-poke agent (bowl run)) %global-store-update !>([%put %home %state 'Illinois']))
  =^  move  agent  (~(on-poke agent (bowl run)) %global-store-update !>([%put %home %zip '61801']))
  =+  !<(=state on-save:agent)
  ;:  weld
  %+  expect-eq
    =|  sto=store:global
    =/  sto  (~(put bi sto) %home %name !>(%home))
    =/  sto  (~(put bi sto) %home %city !>('Champaign'))
    =/  sto  (~(put bi sto) %home %state !>('Illinois'))
    =/  sto  (~(put bi sto) %home %zip !>('61801'))
    !>  :*  %zero
            store=sto
            perms=*perms:global
            whitelist=*whitelist:global
        ==
    !>  state
  ==
++  test-delete-values-in-desk
  =|  run=@ud
  =^  move  agent  (~(on-poke agent (bowl run)) %global-store-update !>([%let %home]))
  =^  move  agent  (~(on-poke agent (bowl run)) %global-store-update !>([%put %home %city 'Champaign']))
  =^  move  agent  (~(on-poke agent (bowl run)) %global-store-update !>([%put %home %state 'Illinois']))
  =^  move  agent  (~(on-poke agent (bowl run)) %global-store-update !>([%put %home %zip '61801']))
  =^  move  agent  (~(on-poke agent (bowl run)) %global-store-update !>([%del %home %city]))
  =^  move  agent  (~(on-poke agent (bowl run)) %global-store-update !>([%del %home %zip]))
  =+  !<(=state on-save:agent)
  ;:  weld
  %+  expect-eq
    =|  sto=store:global
    =/  sto  (~(put bi sto) %home %name !>(%home))
    =/  sto  (~(put bi sto) %home %state !>('Illinois'))
    !>  :*  %zero
            store=sto
            perms=*perms:global
            whitelist=*whitelist:global
        ==
    !>  state
  ==
++  test-set-perms
  =|  run=@ud
  =^  move  agent  (~(on-poke agent (bowl run)) %global-store-update !>([%mode %public %r]))
  =^  move  agent  (~(on-poke agent (bowl run)) %global-store-update !>([%mode %whitelist %w]))
  =^  move  agent  (~(on-poke agent (bowl run)) %global-store-update !>([%mode %team %w]))
  =^  move  agent  (~(on-poke agent (bowl run)) %global-store-update !>([%mode %me %w]))
  =+  !<(=state on-save:agent)
  ;:  weld
  %+  expect-eq
    =|  per=perms:global
    =/  per  (~(put by per) %public %r)
    =/  per  (~(put by per) %whitelist %w)
    =/  per  (~(put by per) %team %w)
    =/  per  (~(put by per) %me %w)
    !>  :*  %zero
            store=*store:global
            perms=per
            whitelist=*whitelist:global
        ==
    !>  state
  ==
::++  test-whitelist
::++  test-blacklist
++  test-lockdown
  =|  run=@ud
  =^  move  agent  (~(on-poke agent (bowl run)) %global-store-update !>([%mode %public %r]))
  =^  move  agent  (~(on-poke agent (bowl run)) %global-store-update !>([%mode %whitelist %w]))
  =^  move  agent  (~(on-poke agent (bowl run)) %global-store-update !>([%mode %team %w]))
  =^  move  agent  (~(on-poke agent (bowl run)) %global-store-update !>([%mode %me %w]))
  =^  move  agent  (~(on-poke agent (bowl run)) %global-store-update !>([%lockdown ~]))
  =+  !<(=state on-save:agent)
  ;:  weld
  %+  expect-eq
    =|  per=perms:global
    =/  per  (~(put by per) %public %$)
    =/  per  (~(put by per) %whitelist %$)
    =/  per  (~(put by per) %team %$)
    =/  per  (~(put by per) %me %w)
    !>  :*  %zero
            store=*store:global
            perms=per
            whitelist=*whitelist:global
        ==
    !>  state
  ==
--
