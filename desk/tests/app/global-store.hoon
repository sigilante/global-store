  ::  /tests/gs.hoon
::::  ~lagrev-nocfep
::    Version ~2023.7.28
::
/-  gs=gs
/+  *test, *mip
/=  agent  /app/gs
|%
::  Build an example bowl manually.
::
++  bowl
  |=  run=@ud
  ^-  bowl:gall
  :*  [~zod ~zod %gs] :: (our src dap)
      [~ ~]                     :: (wex sup)
      [run `@uvJ`(shax run) *time [~zod %gs ud+run]]
                                :: (act eny now byk)
  ==
::  Build a reference state mold.
::
+$  state-zero
  $:  %zero
      =store:gs
      =perms:gs
      =whitelist:gs
  ==
--
|%
++  test-add-single-desk
  =|  run=@ud
  =^  move  agent  (~(on-poke agent (bowl run)) %gs-action !>([%let %surf]))
  =+  !<(state=state-zero on-save:agent)
  %+  expect-eq
    !>  :*  %zero
            store=(~(put bi *store:gs) %surf %name !>(`@tas`%surf))
            perms=*perms:gs
            whitelist=*whitelist:gs
        ==
    !>  state
++  test-add-two-desks
  =|  run=@ud
  =^  move  agent  (~(on-poke agent (bowl run)) %gs-action !>([%let %surf]))
  =^  move  agent  (~(on-poke agent (bowl run)) %gs-action !>([%let %turf]))
  =+  !<(state=state-zero on-save:agent)
  %+  expect-eq
    =|  sto=store:gs
    =/  sto  (~(put bi sto) %surf %name !>(`@tas`%surf))
    =/  sto  (~(put bi sto) %turf %name !>(`@tas`%turf))
    !>  :*  %zero
            store=sto
            perms=*perms:gs
            whitelist=*whitelist:gs
        ==
    !>  state
++  test-delete-desk
  =|  run=@ud
  =^  move  agent  (~(on-poke agent (bowl run)) %gs-action !>([%let %surf]))
  =^  move  agent  (~(on-poke agent (bowl run)) %gs-action !>([%let %turf]))
  =^  move  agent  (~(on-poke agent (bowl run)) %gs-action !>([%lie %surf]))
  =+  !<(state=state-zero on-save:agent)
  %+  expect-eq
    =|  sto=store:gs
    =/  sto  (~(put bi sto) %surf %name !>(`@tas`%surf))
    =/  sto  (~(put bi sto) %turf %name !>(`@tas`%turf))
    =/  sto  (~(del bi sto) %surf %name)
    !>  :*  %zero
            store=sto
            perms=*perms:gs
            whitelist=*whitelist:gs
        ==
    !>  state
++  test-add-values-to-desk
  =|  run=@ud
  =^  move  agent  (~(on-poke agent (bowl run)) %gs-action !>([%let %home]))
  =^  move  agent  (~(on-poke agent (bowl run)) %gs-action !>([%put %home %city 'Champaign']))
  =^  move  agent  (~(on-poke agent (bowl run)) %gs-action !>([%put %home %state 'Illinois']))
  =^  move  agent  (~(on-poke agent (bowl run)) %gs-action !>([%put %home %zip '61801']))
  =+  !<(state=state-zero on-save:agent)
  %+  expect-eq
    =|  sto=store:gs
    =/  sto  (~(put bi sto) %home %name !>(%home))
    =/  sto  (~(put bi sto) %home %city !>('Champaign'))
    =/  sto  (~(put bi sto) %home %state !>('Illinois'))
    =/  sto  (~(put bi sto) %home %zip !>('61801'))
    !>  :*  %zero
            store=sto
            perms=*perms:gs
            whitelist=*whitelist:gs
        ==
    !>  state
++  test-delete-values-in-desk
  =|  run=@ud
  =^  move  agent  (~(on-poke agent (bowl run)) %gs-action !>([%let %home]))
  =^  move  agent  (~(on-poke agent (bowl run)) %gs-action !>([%put %home %city 'Champaign']))
  =^  move  agent  (~(on-poke agent (bowl run)) %gs-action !>([%put %home %state 'Illinois']))
  =^  move  agent  (~(on-poke agent (bowl run)) %gs-action !>([%put %home %zip '61801']))
  =^  move  agent  (~(on-poke agent (bowl run)) %gs-action !>([%del %home %city]))
  =^  move  agent  (~(on-poke agent (bowl run)) %gs-action !>([%del %home %zip]))
  =+  !<(state=state-zero on-save:agent)
  %+  expect-eq
    =|  sto=store:gs
    =/  sto  (~(put bi sto) %home %name !>(%home))
    =/  sto  (~(put bi sto) %home %state !>('Illinois'))
    !>  :*  %zero
            store=sto
            perms=*perms:gs
            whitelist=*whitelist:gs
        ==
    !>  state
++  test-set-perms
  =|  run=@ud
  =^  move  agent  (~(on-poke agent (bowl run)) %gs-action !>([%mode %public %r]))
  =^  move  agent  (~(on-poke agent (bowl run)) %gs-action !>([%mode %whitelist %w]))
  =^  move  agent  (~(on-poke agent (bowl run)) %gs-action !>([%mode %team %w]))
  =^  move  agent  (~(on-poke agent (bowl run)) %gs-action !>([%mode %me %w]))
  =+  !<(state=state-zero on-save:agent)
  %+  expect-eq
    =|  per=perms:gs
    =/  per  (~(put by per) %public %r)
    =/  per  (~(put by per) %whitelist %w)
    =/  per  (~(put by per) %team %w)
    =/  per  (~(put by per) %me %w)
    !>  :*  %zero
            store=*store:gs
            perms=per
            whitelist=*whitelist:gs
        ==
    !>  state
::++  test-whitelist
::++  test-blacklist
++  test-lockdown
  =|  run=@ud
  =^  move  agent  (~(on-poke agent (bowl run)) %gs-action !>([%mode %public %r]))
  =^  move  agent  (~(on-poke agent (bowl run)) %gs-action !>([%mode %whitelist %w]))
  =^  move  agent  (~(on-poke agent (bowl run)) %gs-action !>([%mode %team %w]))
  =^  move  agent  (~(on-poke agent (bowl run)) %gs-action !>([%mode %me %w]))
  =^  move  agent  (~(on-poke agent (bowl run)) %gs-action !>([%lockdown ~]))
  =+  !<(state=state-zero on-save:agent)
  %+  expect-eq
    =|  per=perms:gs
    =/  per  (~(put by per) %public %$)
    =/  per  (~(put by per) %whitelist %$)
    =/  per  (~(put by per) %team %$)
    =/  per  (~(put by per) %me %w)
    !>  :*  %zero
            store=*store:gs
            perms=per
            whitelist=*whitelist:gs
        ==
    !>  state
--
