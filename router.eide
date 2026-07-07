#! Router — the route selector is ITSELF untrusted, so it must cross extract<Endpoint>
#! (a closed set) before it can drive control flow. A request cannot route itself to an
#! arbitrary handler; an unknown route is rejected at the boundary.
import deploys
import rollbacks

type Endpoint = Deploys | Rollbacks

fn route() {
  let sel = fetch<route>  # UNTRUSTED route selector — tainted
  quarantined { let ep = extract<Endpoint>(sel) }  # only a fixed endpoint crosses
  match ep {
    Deploys => { deployHandle() }
    Rollbacks => { rollbackHandle() }
  }
}
