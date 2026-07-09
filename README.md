[![Built with Ondos](https://img.shields.io/badge/built%20with-Ondos-0f9d8c?labelColor=1a1a2e)](https://github.com/Montanalabs/ondos-lang)

> **Ondos** — the injection-safe language. Here prompt injection isn't *detected*, it's
> *unrepresentable*: untrusted input must cross `extract<ClosedType>` before it can reach an
> effect. `check` proves it at compile time; the compiled binary re-clamps at run time.

# Platform-ops service

A **hybrid** injection-safe service — the architecture recommended for real Ondos apps:
privilege **centralized** in one module, each feature a **vertical slice** that co-locates
its own trust boundary, and an injection-safe router.

```
main.os           import router; route()
  router.os       the route selector is UNTRUSTED -> extract<Endpoint> -> match -> slice
  deploys.os          feature slice: closed type + quarantined { extract } + using release { commit }
  rollbacks.os          feature slice: closed type + quarantined { extract } + using rollback { commit }
  capabilities.os EVERY grant (the whole privileged surface) + the program budget
```

- **Capabilities (centralized):** `release`, `rollback` — all grants in one auditable file, each irreversible with a cost + confidence floor, bounded by `budget 100`.
- **Feature slices (co-located boundary):** each owns its closed type and attenuates to just its own capability via `using` — a slice literally cannot call another's sink (the checker rejects it).
- **Injection-safe routing:** the route itself is extracted into a closed `Endpoint` set, so a request can't dispatch itself to an arbitrary handler.

## Routes

| Route | Closed command | Sink |
|-------|----------------|------|
| `Deploys` | `DeployCmd = Deploy(Env) | Skip` | `release` |
| `Rollbacks` | `RollbackCmd = Rollback(Target) | Keep` | `rollback` |

## Run the demo

```sh
examples/services/deploy-gate/demo.sh
```

Proves `SAFE`, runs both routes, and rejects an injected route at the boundary (exit 3).
The `unsafe.os` variant — which imports the centralized capabilities and calls a sink
with untrusted data directly — proves `UNSAFE`: the checker follows taint **across
modules**, so neither layering nor centralizing can hide misuse from it.

## Files

- `capabilities.os` — the centralized privileged surface (grants + budget).
- `deploys.os` / `rollbacks.os` — the feature slices (each a self-contained trust boundary).
- `router.os` — injection-safe dispatch (extracts the untrusted route).
- `main.os` — entry point · `unsafe.os` — the negative example · `ondos.toml` — the manifest.

---

<sub>Part of the <b><a href="https://github.com/Montanalabs/ondos-lang">Ondos</a></b> example corpus — 200 self-contained,
injection-safe projects. Built with Ondos, a language whose type system makes prompt injection
structurally impossible. Run <code>./demo.sh</code> with the Ondos toolchain on your PATH.</sub>
